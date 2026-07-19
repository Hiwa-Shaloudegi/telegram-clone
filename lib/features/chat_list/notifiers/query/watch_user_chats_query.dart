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
        return ChatListItemModel(
          chatId: chat.chatId,
          chatType: chat.chatType,
          title: chat.title,
          description: chat.description,
          imageUrl: chat.imageUrl,
          isPublic: chat.isPublic,
          inviteLink: chat.inviteLink,
          updatedAt: chat.updatedAt,
          memberRole: chat.memberRole,
          isPinned: chat.isPinned,
          isArchived: chat.isArchived,
          isMuted: chat.isMuted,
          lastMessageId: chat.lastMessageId,
          lastMessageContent: chat.lastMessageContent,
          lastMessageType: chat.lastMessageType,
          lastMessageAt: chat.lastMessageAt,
          lastMessageSenderId: chat.lastMessageSenderId,
          lastMessageSenderName: chat.lastMessageSenderName,
          unreadCount: 0, // immediate reset
          otherUserId: chat.otherUserId,
          otherUserName: chat.otherUserName,
          otherUserImage: chat.otherUserImage,
        );
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
        return ChatListItemModel(
          chatId: chat.chatId,
          chatType: chat.chatType,
          title: chat.title,
          description: chat.description,
          imageUrl: chat.imageUrl,
          isPublic: chat.isPublic,
          inviteLink: chat.inviteLink,
          updatedAt: chat.updatedAt,
          memberRole: chat.memberRole,
          isPinned: pin,
          isArchived: chat.isArchived,
          isMuted: chat.isMuted,
          lastMessageId: chat.lastMessageId,
          lastMessageContent: chat.lastMessageContent,
          lastMessageType: chat.lastMessageType,
          lastMessageAt: chat.lastMessageAt,
          lastMessageSenderId: chat.lastMessageSenderId,
          lastMessageSenderName: chat.lastMessageSenderName,
          unreadCount: chat.unreadCount,
          otherUserId: chat.otherUserId,
          otherUserName: chat.otherUserName,
          otherUserImage: chat.otherUserImage,
        );
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
}
