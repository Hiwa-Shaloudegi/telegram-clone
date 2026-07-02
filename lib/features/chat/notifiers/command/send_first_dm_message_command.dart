import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';

part 'send_first_dm_message_command.g.dart';

@riverpod
class SendFirstDmMessageCommand extends _$SendFirstDmMessageCommand {
  @override
  FutureOr<void> build() {}

  Future<String?> run({
    required String otherUserId,
    required String content,
    String? replyToMessageId,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    String? chatId;

    state = await AsyncValue.guard(() async {
      chatId = await ref
          .read(chatsApiProvider)
          .getOrCreatePrivateChat(otherUserId);

      await ref.read(messagesApiProvider).sendTextMessage(
            chatId: chatId!,
            content: content,
            replyToMessageId: replyToMessageId,
          );
    });

    link.close();
    return chatId;
  }
}
