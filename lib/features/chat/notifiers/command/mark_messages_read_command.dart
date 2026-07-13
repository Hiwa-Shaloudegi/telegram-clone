import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/query/watch_messages_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';

part 'mark_messages_read_command.g.dart';

@Riverpod(keepAlive: true)
class MarkMessagesReadCommand extends _$MarkMessagesReadCommand {
  final Set<String> _markedIds = {};

  @override
  void build(String chatId) {}

  void markMessagesAsRead(List<MessageModel> messages) {
    final unreadIds = <String>[];
    for (final msg in messages) {
      if (!msg.isOwnMessage && !msg.isRead && !_markedIds.contains(msg.id)) {
        unreadIds.add(msg.id);
        _markedIds.add(msg.id);
      }
    }

    if (unreadIds.isEmpty) return;

    ref
        .read(watchUserChatsQueryProvider.notifier)
        .optimisticallyMarkAsRead(chatId);

    ref
        .read(watchMessagesQueryProvider(chatId).notifier)
        .optimisticallyMarkMessagesAsRead(unreadIds);

    ref.read(chatsApiProvider).markMessagesRead(unreadIds, chatId);
  }
}
