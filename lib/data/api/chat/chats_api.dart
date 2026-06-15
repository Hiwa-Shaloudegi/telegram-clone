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

  Stream<List<ChatListItemModel>> watchUserChats() {
    final controller = StreamController<List<ChatListItemModel>>.broadcast();

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      controller.addError(Exception('Not authenticated'));
      return controller.stream;
    }

    // helper: fetch and push
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

    final channel = supabase
        .channel('chats_list_$currentUserId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (_) => fetch(),
        )
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
