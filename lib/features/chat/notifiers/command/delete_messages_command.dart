import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/api/messages/messages_api.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';

part 'delete_messages_command.g.dart';

@riverpod
class DeleteMessagesCommand extends _$DeleteMessagesCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String chatId,
    required ChatType chatType,
    bool deleteForEveryone = false,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    final HashSet<String> messageIds = ref.read(
      chatUi_selectedMessagesProvider,
    );

    if (messageIds.isEmpty) {
      link.close();
      return;
    }

    // Optimistic update
    ref
        .read(watchMessagesQueryProvider(chatId).notifier)
        .update(
          (messages) =>
              messages.where((m) => !messageIds.contains(m.id)).toList(),
        );
    final result = await AsyncValue.guard(
      () => ref
          .watch(messagesApiProvider)
          .bulkDeleteMessages(
            messageIds: messageIds,
            chatType: chatType,
            deleteForEveryone: deleteForEveryone,
          ),
    );
    state = result;

    link.close();
  }
}
