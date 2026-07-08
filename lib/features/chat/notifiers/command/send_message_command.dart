import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';
import 'package:uuid/uuid.dart';

part 'send_message_command.g.dart';

@riverpod
class SendMessageCommand extends _$SendMessageCommand {
  @override
  FutureOr<void> build(String messageTempId) {}

  /// Resolves a pending chatId to a real one by calling
  /// `get_or_create_private_chat`. If [chatId] is not pending it is returned
  /// as-is. Also updates [mainUi_selectedChatItemProviderProvider] so the UI
  /// can pick up the real chatId immediately.
  Future<String> _resolveChatId(String chatId) async {
    if (!chatId.startsWith('pending_')) return chatId;

    final otherUserId = chatId.substring('pending_'.length);
    final realChatId =
        await ref.read(chatsApiProvider).getOrCreatePrivateChat(otherUserId);

    // Update the selected-chat provider so the chat page can re-navigate.
    final current = ref.read(mainUi_selectedChatItemProviderProvider);
    if (current != null && current.chatId == chatId) {
      ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(
        ChatListItemModel(
          chatId: realChatId,
          chatType: current.chatType,
          isPublic: current.isPublic,
          updatedAt: current.updatedAt,
          memberRole: current.memberRole,
          isPinned: current.isPinned,
          isArchived: current.isArchived,
          isMuted: current.isMuted,
          unreadCount: current.unreadCount,
          otherUserId: current.otherUserId,
          otherUserName: current.otherUserName,
          otherUserImage: current.otherUserImage,
        ),
      );
    }

    return realChatId;
  }

  Future<void> sendText({
    required String chatId,
    required String content,
    required MessageModel? replyingToMessage,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    // 1. Show the optimistic message immediately in the UI (the page is
    //    currently watching the pending chatId's provider).
    ref
        .read(watchMessagesQueryProvider(chatId).notifier)
        .addOptimisticMessage(
          chatId: chatId,
          messageTempId: messageTempId,
          content: content,
          messageType: 'text',
          replyingToMessage: replyingToMessage,
        );

    // 2. Resolve the pending chatId to the real one (creates the chat row
    //    in the backend via get_or_create_private_chat).
    final resolvedChatId = await _resolveChatId(chatId);

    // 3. If the chatId changed (was pending), also seed the real provider
    //    so that after re-navigation the message is already visible there.
    if (resolvedChatId != chatId) {
      ref
          .read(watchMessagesQueryProvider(resolvedChatId).notifier)
          .addOptimisticMessage(
            chatId: resolvedChatId,
            messageTempId: messageTempId,
            content: content,
            messageType: 'text',
            replyingToMessage: replyingToMessage,
          );
    }

    // 4. Send the message using the real chatId.
    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .sendTextMessage(
            chatId: resolvedChatId,
            content: content,
            replyToMessageId: replyingToMessage?.id,
          ),
    );
    link.close();
  }

  Future<void> sendMedia({
    required String chatId,
    required File file,
    required String messageType,
    String? replyToMessageId,
  }) async {
    state = const AsyncValue.loading();

    final resolvedChatId = await _resolveChatId(chatId);

    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .sendMediaMessage(
            chatId: resolvedChatId,
            file: file,
            messageType: messageType,
            replyToMessageId: replyToMessageId,
          ),
    );
  }

  Future<void> sendForward({
    required String chatId,
    required List<MessageModel> originalMessages,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    final resolvedChatId = await _resolveChatId(chatId);
    final currentUserId = ref.read(messagesApiProvider).currentUser?.id;

    for (final originalMessage in originalMessages) {
      final tempId = 'temp_${const Uuid().v4()}';
      final isOwnOriginal = originalMessage.senderId == currentUserId;

      ref
          .read(watchMessagesQueryProvider(resolvedChatId).notifier)
          .addOptimisticForwardMessage(
            chatId: resolvedChatId,
            messageTempId: tempId,
            content: originalMessage.content,
            messageType: originalMessage.messageType,
            mediaUrl: originalMessage.mediaUrl,
            originalMessageId: originalMessage.id,
            forwardedFromChatId: originalMessage.chatId,
            forwardedFromTitle: isOwnOriginal
                ? null
                : originalMessage.senderName,
          );

      state = await AsyncValue.guard(
        () => ref.read(messagesApiProvider).sendTextMessage(
              chatId: resolvedChatId,
              content: originalMessage.content,
              isForwarded: !isOwnOriginal,
              forwardedFromChatId: originalMessage.chatId,
              forwardedFromTitle: isOwnOriginal
                  ? null
                  : originalMessage.senderName,
              forwardedFromSenderId: originalMessage.senderId,
            ),
      );
    }

    link.close();
  }
}
