import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/models/message_model.dart';
import 'package:telegram_clone/features/chat/notifiers/ui/chat_ui_state.dart';
import 'package:telegram_clone/features/chat/ui/widgets/date_divider.dart';
import 'package:telegram_clone/features/chat/ui/widgets/message_bubble.dart';

class ChatMessagesList extends ConsumerWidget {
  final String chatId;
  final ChatType chatType;
  final List<MessageModel> messages;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final void Function(MessageModel) onReply;
  final void Function(MessageModel) onDelete;

  const ChatMessagesList({
    super.key,
    required this.chatId,
    required this.chatType,
    required this.messages,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (messages.isEmpty) {
      return const Center(child: Text('No messages yet. Say hi! 👋'));
    }

    return ListView.builder(
      controller: scrollController,
      reverse: true, // newest at bottom
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: messages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoadingMore && index == messages.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final msg = messages[index];

        // Determine if a date divider is needed
        final bool showDateDivider;
        if (index == messages.length - 1) {
          showDateDivider = true;
        } else {
          final next =
              messages[index + 1]; // older message (higher index in reversed)
          showDateDivider = !_sameDay(msg.createdAt, next.createdAt);
        }

        // Should the avatar/sender name be shown?
        final bool showSenderInfo;
        final isDMChat = chatType == ChatType.private;
        if (isDMChat) {
          showSenderInfo = false;
        } else if (index == 0) {
          showSenderInfo = true;
        } else {
          final prev = messages[index - 1]; // newer message
          showSenderInfo =
              prev.senderId != msg.senderId ||
              msg.createdAt.difference(prev.createdAt).abs() >
                  const Duration(minutes: 5);
        }

        return Column(
          children: [
            if (showDateDivider) DateDivider(date: msg.createdAt),
            Consumer(
              builder: (_, ref, _) {
                final isSelected = ref.watch(
                  chatUi_selectedMessagesProvider.select(
                    (selected) => selected.contains(msg.id),
                  ),
                );

                final isSelectionMode = ref.watch(
                  chatUi_isSelectionModeProvider,
                );
                return MessageBubble(
                  message: msg,
                  showSenderInfo: showSenderInfo,
                  tileBackgroundColor: isSelected
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  onTap: isSelectionMode
                      ? () => ref
                            .read(chatUi_selectedMessagesProvider.notifier)
                            .toggle(msg.id)
                      : () {},

                  onLongPress: isSelectionMode
                      ? null
                      : () => ref
                            .read(chatUi_selectedMessagesProvider.notifier)
                            .toggle(msg.id),
                  onDelete: () => onDelete(msg),
                  // messageStatus: MessageStatus.sent, // TODO: msg.isRead ? MessageStatus.read : MessageStatus.sent,
                  // onTap: isSelectionMode
                  //     ? () => ref
                  //           .read(chatUi_selectedMessagesProvider.notifier)
                  //           .toggle(msg.id)
                  //     : () {},

                  // onLongPress: isSelectionMode
                  //     ? null
                  //     : () => ref
                  //           .read(chatUi_selectedMessagesProvider.notifier)
                  //           .toggle(msg.id),
                  onReply: () => onReply(msg),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
