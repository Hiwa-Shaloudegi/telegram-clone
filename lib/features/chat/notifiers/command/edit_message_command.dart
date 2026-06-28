import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';

part 'edit_message_command.g.dart';

@riverpod
class EditMessageCommand extends _$EditMessageCommand {
  @override
  FutureOr<void> build(String messageId) {}

  Future<void> editText({
    required String chatId,
    required String messageId,
    required String newContent,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    // optimistic update
    ref
        .read(watchMessagesQueryProvider(chatId).notifier)
        .updateOptimisticMessage(messageId: messageId, newContent: newContent);

    state = await AsyncValue.guard(
      () => ref
          .read(messagesApiProvider)
          .editMessage(messageId: messageId, newContent: newContent),
    );

    link.close();
  }
}
