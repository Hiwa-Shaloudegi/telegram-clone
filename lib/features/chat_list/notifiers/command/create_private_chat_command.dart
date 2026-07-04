import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';

part 'create_private_chat_command.g.dart';

@riverpod
class CreatePrivateChatCommand extends _$CreatePrivateChatCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String otherUserId,
    required String displayName,
    String? profileImageUrl,
    bool isOnline = false,
    DateTime? lastSeenAt,
    required GoRouter router,
  }) async {
    // Fast path: a DM with this person may already exist in the chat list
    // cache (already fetched for the chat list page). If so, navigate
    // immediately with no network round-trip.
    final cachedChats = ref.read(watchUserChatsQueryProvider).value;
    final existing = cachedChats
        ?.where(
          (c) => c.chatType == ChatType.private && c.otherUserId == otherUserId,
        )
        .firstOrNull;

    if (existing != null) {
      ref
          .read(mainUi_selectedChatItemProviderProvider.notifier)
          .set(existing);
      router.pushNamed(
        RouteNames.chat,
        pathParameters: {'chatId': existing.chatId},
      );
      return;
    }

    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final chatId = await ref
          .read(chatsApiProvider)
          .getOrCreatePrivateChat(otherUserId);

      final chatInfo = ChatListItemModel(
        chatId: chatId,
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
        pathParameters: {'chatId': chatId},
      );
    });

    link.close();
  }
}
