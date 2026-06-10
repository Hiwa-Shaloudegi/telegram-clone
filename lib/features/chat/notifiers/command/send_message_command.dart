// lib/features/chat/notifiers/command/send_message_command.dart
// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';

part 'send_message_command.g.dart';

@riverpod
class SendMessageCommand extends _$SendMessageCommand {
  @override
  FutureOr<void> build() {}

  Future<void> sendText({
    required String chatId,
    required String content,
    String? replyToMessageId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .sendTextMessage(
            chatId: chatId,
            content: content,
            replyToMessageId: replyToMessageId,
          ),
    );
  }

  Future<void> sendMedia({
    required String chatId,
    required File file,
    required String messageType,
    String? replyToMessageId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .sendMediaMessage(
            chatId: chatId,
            file: file,
            messageType: messageType,
            replyToMessageId: replyToMessageId,
          ),
    );
  }
}
