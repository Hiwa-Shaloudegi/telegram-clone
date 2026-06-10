import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'chats_api.g.dart';

@Riverpod(keepAlive: true)
ChatsApi chatsApi(Ref ref) {
  return ChatsApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class ChatsApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;
  final _log = Logger();

  ChatsApi({required this.supabase, required this.exceptionHandler});

  /// Returns a stream of the current user's chat list.
  ///
  /// The stream emits a new list whenever:
  ///   - A new message arrives in any of the user's chats  (messages INSERT)
  ///   - A chat_members row changes (pin / archive / mute / last_read)
  ///   - A chat row changes (title, image, etc.)
  ///
  /// We achieve live updates by subscribing to Supabase Realtime on the
  /// `messages` and `chat_members` tables (filtered to the current user)
  /// and re-fetching the full list via the `get_user_chats` RPC on every
  /// relevant event.
  Stream<List<ChatListItemModel>> watchUserChats() {
    // StreamController so we can push new data from multiple realtime callbacks
    final controller = StreamController<List<ChatListItemModel>>.broadcast();

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      controller.addError(Exception('Not authenticated'));
      return controller.stream;
    }

    // --- helper: fetch and push ---
    Future<void> fetch() async {
      try {
        final raw = await supabase.rpc('get_user_chats') as List<dynamic>;
        final items = raw
            .map((e) => ChatListItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (!controller.isClosed) controller.add(items);
      } catch (e, st) {
        _log.e('watchUserChats fetch error', error: e, stackTrace: st);
        if (!controller.isClosed) controller.addError(e);
      }
    }

    // initial load
    fetch();

    // --- Realtime subscriptions ---
    // 1. New messages in any chat → re-fetch list (last message + unread)
    // 2. chat_members changes for current user → re-fetch (pin/archive/mute/read)
    // 3. chats changes → re-fetch (title/image updates)
    final channel = supabase
        .channel('chats_list_$currentUserId')
        // messages: any INSERT (we don't filter by chat_id here because
        // the user may be in many chats — the RPC will handle the filtering)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (_) => fetch(),
        )
        // chat_members: changes for the current user
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chat_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUserId,
          ),
          callback: (_) => fetch(),
        )
        // chats: any update (title, image_url, etc.)
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chats',
          callback: (_) => fetch(),
        )
        .subscribe((status, [error]) {
          if (error != null) {
            _log.e('Realtime subscription error: $error');
          }
        });

    // Clean up channel when the stream is no longer listened to
    controller.onCancel = () {
      supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  /// Mark all messages in [chatId] as read (updates last_read_message_id).
  Future<void> markChatRead(String chatId) async {
    try {
      await supabase.rpc('mark_chat_read', params: {'p_chat_id': chatId});
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

  /// Toggle pin status for the current user in [chatId].
  Future<void> togglePin(String chatId, {required bool pin}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('chat_members')
          .update({'is_pinned': pin})
          .eq('chat_id', chatId)
          .eq('user_id', userId);
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

  /// Toggle archive status.
  Future<void> toggleArchive(String chatId, {required bool archive}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('chat_members')
          .update({'is_archived': archive})
          .eq('chat_id', chatId)
          .eq('user_id', userId);
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }

  /// Toggle mute status.
  Future<void> toggleMute(String chatId, {required bool mute}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('chat_members')
          .update({'is_muted': mute})
          .eq('chat_id', chatId)
          .eq('user_id', userId);
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }
}
