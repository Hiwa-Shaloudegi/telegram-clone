// lib/data/api/messages/messages_api.dart
// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'messages_api.g.dart';

@Riverpod(keepAlive: true)
MessagesApi messagesApi(Ref ref) {
  return MessagesApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class MessagesApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;
  final _log = Logger();

  MessagesApi({required this.supabase, required this.exceptionHandler});

  // ----------------------------------------------------------------
  // Watch messages for a chat (live stream)
  // ----------------------------------------------------------------

  /// Returns a live stream of messages for [chatId].
  ///
  /// Strategy:
  ///   1. Initial load via `get_chat_messages` RPC (returns enriched rows).
  ///   2. Subscribe to Realtime INSERT on `messages` filtered by chat_id.
  ///      On new message, fetch the enriched version and prepend to list.
  ///   3. Subscribe to Realtime UPDATE/DELETE so edits & soft-deletes propagate.
  Stream<List<MessageModel>> watchMessages(String chatId) {
    final controller = StreamController<List<MessageModel>>.broadcast();

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      controller.addError(AppException(message: 'Not authenticated'));
      return controller.stream;
    }

    // Mutable in-memory list — newest first (index 0 = latest)
    List<MessageModel> messages = [];

    // ── initial fetch ────────────────────────────────────────────
    Future<void> initialLoad() async {
      try {
        final raw =
            await supabase.rpc(
                  'get_chat_messages',
                  params: {'p_chat_id': chatId, 'p_limit': 50},
                )
                as List<dynamic>;

        messages = raw
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList(); // already DESC from RPC

        if (!controller.isClosed) controller.add(List.unmodifiable(messages));
      } catch (e, st) {
        _log.e('watchMessages initial load', error: e, stackTrace: st);
        if (!controller.isClosed) controller.addError(e);
      }
    }

    // ── fetch a single message by id (to enrich realtime inserts) ─
    Future<MessageModel?> fetchSingleMessage(String messageId) async {
      try {
        final raw = await supabase
            .from('messages')
            .select('''
              id, chat_id, sender_id, content, message_type,
              media_url, reply_to_message_id, is_forwarded,
              forwarded_from_chat_id, created_at, updated_at,
              users!sender_id ( display_name, first_name, last_name, profile_image_url ),
              reply_msg:messages!reply_to_message_id (
                content,
                users!sender_id ( display_name, first_name, last_name )
              ),
              fwd_chat:chats!forwarded_from_chat_id ( title )
            ''')
            .eq('id', messageId)
            .maybeSingle();

        if (raw == null) return null;

        final senderRaw = raw['users'] as Map<String, dynamic>?;
        final senderName = senderRaw != null
            ? (senderRaw['display_name'] as String? ??
                      '${senderRaw['first_name']} ${senderRaw['last_name'] ?? ''}')
                  .trim()
            : '';
        final senderImage = senderRaw?['profile_image_url'] as String?;

        final replyRaw = raw['reply_msg'] as Map<String, dynamic>?;
        final replyUser = replyRaw?['users'] as Map<String, dynamic>?;
        final replyToContent = replyRaw?['content'] as String?;
        final replyToSenderName = replyUser != null
            ? (replyUser['display_name'] as String? ??
                      '${replyUser['first_name']} ${replyUser['last_name'] ?? ''}')
                  .trim()
            : null;

        final fwdChat = raw['fwd_chat'] as Map<String, dynamic>?;

        return MessageModel(
          id: raw['id'] as String,
          chatId: raw['chat_id'] as String,
          senderId: raw['sender_id'] as String,
          senderName: senderName,
          senderImage: senderImage,
          content: raw['content'] as String? ?? '',
          messageType: raw['message_type'] as String? ?? 'text',
          mediaUrl: raw['media_url'] as String?,
          replyToMessageId: raw['reply_to_message_id'] as String?,
          replyToContent: replyToContent,
          replyToSenderName: replyToSenderName,
          isForwarded: raw['is_forwarded'] as bool? ?? false,
          forwardedFromChatId: raw['forwarded_from_chat_id'] as String?,
          forwardedFromTitle: fwdChat?['title'] as String?,
          createdAt: DateTime.parse(raw['created_at'] as String),
          updatedAt: DateTime.parse(raw['updated_at'] as String),
          isOwnMessage: raw['sender_id'] == currentUserId,
        );
      } catch (e) {
        _log.e('fetchSingleMessage error', error: e);
        return null;
      }
    }

    initialLoad();

    // ── Realtime subscription ─────────────────────────────────────
    final channel = supabase
        .channel('messages_$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) async {
            final newId = payload.newRecord['id'] as String?;
            if (newId == null) return;

            // Fetch enriched version
            final enriched = await fetchSingleMessage(newId);
            if (enriched == null) return;

            // Prepend (newest first) — avoid duplicates
            if (messages.any((m) => m.id == newId)) return;
            messages = [enriched, ...messages];
            if (!controller.isClosed) {
              controller.add(List.unmodifiable(messages));
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) async {
            final updatedId = payload.newRecord['id'] as String?;
            if (updatedId == null) return;

            final enriched = await fetchSingleMessage(updatedId);
            if (enriched == null) return;

            messages = messages
                .map((m) => m.id == updatedId ? enriched : m)
                .toList();
            if (!controller.isClosed) {
              controller.add(List.unmodifiable(messages));
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) {
            final deletedId = payload.oldRecord['id'] as String?;
            if (deletedId == null) return;
            messages = messages.where((m) => m.id != deletedId).toList();
            if (!controller.isClosed) {
              controller.add(List.unmodifiable(messages));
            }
          },
        )
        .subscribe((status, [error]) {
          if (error != null) {
            _log.e('Messages realtime error: $error');
          }
        });

    controller.onCancel = () {
      supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  // ----------------------------------------------------------------
  // Load older messages (pagination)
  // ----------------------------------------------------------------

  Future<List<MessageModel>> loadMoreMessages({
    required String chatId,
    required String beforeMessageId,
    int limit = 30,
  }) async {
    try {
      final raw =
          await supabase.rpc(
                'get_chat_messages',
                params: {
                  'p_chat_id': chatId,
                  'p_before_id': beforeMessageId,
                  'p_limit': limit,
                },
              )
              as List<dynamic>;

      return raw
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      exceptionHandler.handle(e);
      return [];
    }
  }

  // ----------------------------------------------------------------
  // Send message
  // ----------------------------------------------------------------

  Future<String?> sendTextMessage({
    required String chatId,
    required String content,
    String? replyToMessageId,
  }) async {
    try {
      final result = await supabase.rpc(
        'send_message',
        params: {
          'p_chat_id': chatId,
          'p_content': content,
          'p_message_type': 'text',
          if (replyToMessageId != null)
            'p_reply_to_message_id': replyToMessageId,
        },
      );
      return result as String?;
    } catch (e) {
      exceptionHandler.handle(e);
      return null;
    }
  }

  /// Upload a file (image/video/audio/file) to Supabase Storage,
  /// then insert a message pointing to it.
  Future<String?> sendMediaMessage({
    required String chatId,
    required File file,
    required String messageType, // image | video | audio | file
    String? replyToMessageId,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final ext = file.path.split('.').last;
      final storagePath =
          'chats/$chatId/$userId/${DateTime.now().millisecondsSinceEpoch}.$ext';

      await supabase.storage
          .from('media')
          .upload(
            storagePath,
            file,
            fileOptions: const FileOptions(upsert: false),
          );

      final mediaUrl = supabase.storage.from('media').getPublicUrl(storagePath);

      final result = await supabase.rpc(
        'send_message',
        params: {
          'p_chat_id': chatId,
          'p_content': _captionForType(messageType),
          'p_message_type': messageType,
          'p_media_url': mediaUrl,
          if (replyToMessageId != null)
            'p_reply_to_message_id': replyToMessageId,
        },
      );
      return result as String?;
    } catch (e) {
      exceptionHandler.handle(e);
      return null;
    }
  }

  String _captionForType(String type) {
    switch (type) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎵 Voice message';
      default:
        return '📎 File';
    }
  }

  // ----------------------------------------------------------------
  // Search messages by date
  // ----------------------------------------------------------------

  Future<List<MessageModel>> getMessagesByDate({
    required String chatId,
    required DateTime date,
  }) async {
    try {
      final dateStr =
          '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final raw =
          await supabase.rpc(
                'get_messages_by_date',
                params: {'p_chat_id': chatId, 'p_date': dateStr},
              )
              as List<dynamic>;

      return raw
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      exceptionHandler.handle(e);
      return [];
    }
  }

  // ----------------------------------------------------------------
  // Delete / soft-delete a message
  // ----------------------------------------------------------------

  Future<void> deleteMessage(String messageId) async {
    try {
      await supabase
          .from('messages')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', messageId)
          .eq('sender_id', supabase.auth.currentUser!.id);
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }
}
