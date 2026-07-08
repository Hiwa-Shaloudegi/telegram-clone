import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
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

  MessagesApi({required this.supabase, required this.exceptionHandler});

  User? get currentUser => supabase.auth.currentUser;

  Stream<List<MessageModel>> watchMessages(String chatId) {
    if (chatId.startsWith('pending_')) {
      return Stream.value([]);
    }
    try {
      late StreamController<List<MessageModel>> controller;

      Future<void> load() async {
        final rows = await supabase.rpc(
          'get_chat_messages',
          params: {'p_chat_id': chatId, 'p_limit': 50},
        );

        controller.add(
          (rows as List).map((e) => MessageModel.fromJson(e)).toList(),
        );
      }

      controller = StreamController(
        onListen: () async {
          await load();

          final channel = supabase.channel('messages-$chatId')
            ..onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'chat_id',
                value: chatId,
              ),
              callback: (_) async {
                await load();
              },
            ).subscribe();

          controller.onCancel = () {
            supabase.removeChannel(channel);
          };
        },
      );

      return controller.stream;
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

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
    }
  }

  Future<String?> sendTextMessage({
    required String chatId,
    required String content,
    String? replyToMessageId,
    bool isForwarded = false,
    String? forwardedFromChatId,
    String? forwardedFromTitle,
    String? forwardedFromSenderId,
  }) async {
    try {
      final result = await supabase.rpc(
        'send_message',
        params: {
          'p_chat_id': chatId,
          'p_content': content,
          'p_message_type': 'text',
          'p_reply_to_message_id': ?replyToMessageId,
          'p_is_forwarded': isForwarded,
          'p_forwarded_from_chat_id': ?forwardedFromChatId,
          'p_forwarded_from_title': ?forwardedFromTitle,
          'p_forwarded_from_sender_id': ?forwardedFromSenderId,
        },
      );
      return result as String?;
    } catch (e) {
      exceptionHandler.handle(e);
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
          'p_reply_to_message_id': ?replyToMessageId,
        },
      );
      return result as String?;
    } catch (e) {
      exceptionHandler.handle(e);
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
    }
  }


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

  Future<int> bulkDeleteMessages({
    required HashSet<String> messageIds,
    required ChatType chatType,
    bool deleteForEveryone = false,
  }) async {
    try {
      final response = await supabase.rpc(
        'bulk_delete_messages',
        params: {
          'p_message_ids': messageIds.toList(),
          'p_acting_user_id': currentUser?.id,
          'p_delete_for_everyone': chatType != ChatType.private
              ? true // always hard-delete in groups/channels
              : deleteForEveryone,
        },
      );

      return response as int;
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

  /// Edit a text message. Only the sender may edit their message.
  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      await supabase
          .from('messages')
          .update({'content': newContent, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', messageId)
          .eq('sender_id', supabase.auth.currentUser!.id);
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }
}
