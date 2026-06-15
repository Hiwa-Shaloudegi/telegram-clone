// lib/features/chat/notifiers/query/watch_messages_query.dart
// ignore_for_file: public_member_api_docs

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/message_model.dart';

part 'watch_messages_query.g.dart';

/// Live stream of messages for the given [chatId].
@riverpod
Stream<List<MessageModel>> watchMessagesQuery(Ref ref, String chatId) {
  return ref.read(messagesApiProvider).watchMessages(chatId);
}
