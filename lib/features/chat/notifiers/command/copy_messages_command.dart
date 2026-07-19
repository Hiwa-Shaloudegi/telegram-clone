import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';

part 'copy_messages_command.g.dart';

@riverpod
class CopyMessagesCommand extends _$CopyMessagesCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({required String chatId}) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    final HashSet<String> messageIds = ref.read(
      chatUi_selectedMessagesProvider,
    );

    if (messageIds.isEmpty) {
      link.close();
      return;
    }

    final messagesAsync = ref.read(watchMessagesQueryProvider(chatId));
    final result = await AsyncValue.guard(() async {
      final selectedMessages = messagesAsync.whenData((messages) {
        final result = <String>[];
        for (final msg in messages.reversed) {
          if (messageIds.contains(msg.id) && msg.content.isNotEmpty) {
            result.add(msg.content);
          }
        }
        return result;
      }).value;

      if (selectedMessages == null || selectedMessages.isEmpty) return;

      final text = selectedMessages.join('\n');

      await Clipboard.setData(ClipboardData(text: text));
    });

    state = result;

    ref.read(chatUi_selectedMessagesProvider.notifier).clear();

    link.close();
  }
}
