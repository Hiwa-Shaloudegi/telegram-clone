import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

part 'watch_messages_query.g.dart';

@riverpod
class WatchMessagesQuery extends _$WatchMessagesQuery {
  @override
  Stream<List<MessageModel>> build(String chatId) {
    return ref.read(messagesApiProvider).watchMessages(chatId);
  }

  void addOptimisticMessage({
    required String chatId,
    required String messageTempId,
    required String content,
    required String messageType,
    required MessageModel? replyingToMessage,
  }) async {
    final userProfile = await ref.read(userProfileQueryProvider.future);
    if (userProfile == null) return;

    final msg = MessageModel(
      id: messageTempId,
      chatId: chatId,
      senderId: userProfile.id,
      senderName: userProfile.displayName,
      content: content,
      messageType: messageType,
      isForwarded: false,
      createdAt: DateTime.now(),
      replyToContent: replyingToMessage?.content,
      replyToMessageId: replyingToMessage?.id,
      replyToSenderName: replyingToMessage?.senderName,
      updatedAt: DateTime.now(),
      isOwnMessage: true,
    );
    state = AsyncValue.data([msg, ...?state.asData?.value]);
  }

  void updateOptimisticMessage({
    required String messageId,
    required String newContent,
  }) {
    final now = DateTime.now();
    final current = state.asData?.value ?? [];
    final updated = current.map((m) {
      if (m.id == messageId) {
        return MessageModel(
          id: m.id,
          chatId: m.chatId,
          senderId: m.senderId,
          senderName: m.senderName,
          senderImage: m.senderImage,
          content: newContent,
          messageType: m.messageType,
          mediaUrl: m.mediaUrl,
          replyToMessageId: m.replyToMessageId,
          replyToContent: m.replyToContent,
          replyToSenderName: m.replyToSenderName,
          isForwarded: m.isForwarded,
          forwardedFromChatId: m.forwardedFromChatId,
          forwardedFromTitle: m.forwardedFromTitle,
          createdAt: m.createdAt,
          updatedAt: now,
          isOwnMessage: m.isOwnMessage,
        );
      }
      return m;
    }).toList();

    state = AsyncValue.data(updated);
  }

  void removeMessage(String messageId) {
    final current = state.asData?.value ?? [];
    state = AsyncValue.data(
      current.where((m) => m.id != messageId).toList(),
    );
  }
}
