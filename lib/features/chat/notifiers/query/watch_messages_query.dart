// lib/features/chat/notifiers/query/watch_messages_query.dart
// ignore_for_file: public_member_api_docs

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
    required String content,
    required String messageType,
  }) {
    ref.read(userProfileQueryProvider).whenData((userProfile) {
      final msg = MessageModel(
        id: '',
        chatId: chatId,
        senderId: userProfile.id,
        senderName: userProfile.displayName,
        content: content,
        messageType: messageType,
        isForwarded: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOwnMessage: true,
      );
      state = AsyncValue.data([msg, ...?state.asData?.value]);
    });
  }
}
