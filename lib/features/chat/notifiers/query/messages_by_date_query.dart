// lib/features/chat/notifiers/query/messages_by_date_query.dart
// ignore_for_file: public_member_api_docs

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/data/models/message_model.dart';

part 'messages_by_date_query.g.dart';

@riverpod
class MessagesByDateQuery extends _$MessagesByDateQuery {
  @override
  FutureOr<List<MessageModel>> build() => [];

  Future<void> search({required String chatId, required DateTime date}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .getMessagesByDate(chatId: chatId, date: date),
    );
  }
}
