import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:uuid/uuid.dart';

part 'watch_messages_query.g.dart';

@riverpod
class WatchMessagesQuery extends _$WatchMessagesQuery {
  @override
  Stream<List<MessageModel>> build(String chatId) {
    return ref.read(messagesApiProvider).watchMessages(chatId);
  }

  void addOptimisticMessage({
    required String chatId,
    required String content,
    required String messageType,
    required MessageModel? replyingToMessage,
  }) async {
    final userProfile = await ref.read(userProfileQueryProvider.future);
    if (userProfile == null) return;

    final tempId = 'temp_${Uuid().v4()}';

    final msg = MessageModel(
      id: tempId,
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
}
