import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';

part 'create_private_chat_command.g.dart';

@riverpod
class CreatePrivateChatCommand extends _$CreatePrivateChatCommand {
  @override
  FutureOr<void> build() {}

  /// Navigates to the given contact's chat page instantly.
  ///
  /// No backend chat row is created here. If a DM with this person already
  /// exists (found in the chat list cache) we navigate straight to it.
  /// Otherwise we navigate to a placeholder "pending" chat page — the real
  /// `chats` row is only created once the user actually sends their first
  /// message (see ChatPage._sendText).
  void run({
    required String otherUserId,
    required String displayName,
    String? profileImageUrl,
    bool isOnline = false,
    DateTime? lastSeenAt,
    required GoRouter router,
  }) {
    final cachedChats = ref.read(watchUserChatsQueryProvider).value;
    final existing = cachedChats
        ?.where(
          (c) => c.chatType == ChatType.private && c.otherUserId == otherUserId,
        )
        .firstOrNull;

    if (existing != null) {
      ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(existing);
      router.pushNamed(
        RouteNames.chat,
        pathParameters: {'chatId': existing.chatId},
        extra: existing,
      );
      return;
    }

    final pendingChatId = 'pending_$otherUserId';
    final chatInfo = ChatListItemModel(
      chatId: pendingChatId,
      chatType: ChatType.private,
      isPublic: false,
      updatedAt: DateTime.now(),
      memberRole: 'member',
      isPinned: false,
      isArchived: false,
      isMuted: false,
      unreadCount: 0,
      otherUserId: otherUserId,
      otherUserName: displayName,
      otherUserImage: profileImageUrl,
    );
    ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(chatInfo);

    router.pushNamed(
      RouteNames.chat,
      pathParameters: {'chatId': pendingChatId},
      extra: chatInfo,
    );
  }
}
