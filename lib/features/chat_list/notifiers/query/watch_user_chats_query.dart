import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

part 'watch_user_chats_query.g.dart';

@riverpod
class WatchUserChatsQuery extends _$WatchUserChatsQuery {
  @override
  Stream<List<ChatListItemModel>> build() {
    return ref.read(chatsApiProvider).watchUserChats();
  }

  /// Immediately decrease unread count for a chat (optimistic update).
  /// This updates the UI before the server confirms via Realtime.
  void optimisticallyMarkAsRead(String chatId) {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = current.map((chat) {
      if (chat.chatId == chatId && chat.unreadCount > 0) {
        return chat.copyWith(unreadCount: 0);
      }
      return chat;
    }).toList();

    state = AsyncData(updated);
  }

  /// Immediately toggle pin state for the given chat IDs (optimistic update).
  /// Pinned chats are moved to the top of the list instantly.
  void optimisticallyTogglePin(List<String> chatIds, {required bool pin}) {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = current.map((chat) {
      if (chatIds.contains(chat.chatId)) {
        return chat.copyWith(isPinned: pin);
      }
      return chat;
    }).toList();

    updated.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    state = AsyncData(updated);
  }

  /// Immediately toggle archive state for the given chat IDs (optimistic update).
  /// Archived chats leave the main list (and return on unarchive) instantly.
  void optimisticallyToggleArchive(
    List<String> chatIds, {
    required bool archive,
  }) {
    final current = state.asData?.value;
    if (current == null) return;

    final idSet = chatIds.toSet();
    final updated = current.map((chat) {
      if (idSet.contains(chat.chatId)) {
        // Archiving removes the chat from the main pin section immediately.
        return chat.copyWith(
          isArchived: archive,
          isPinned: archive ? false : chat.isPinned,
        );
      }
      return chat;
    }).toList();

    state = AsyncData(updated);
  }
}
