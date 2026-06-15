
import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

class LastMessageRow extends StatelessWidget {
  final ChatListItemModel item;
  const LastMessageRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (item.lastMessageContent == null) {
      return Text(
        'No messages yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final isGroup = item.chatType == 'group' || item.chatType == 'channel';
    final senderName = item.lastMessageSenderName ?? '';
    final preview = item.lastMessagePreview;

    return Text.rich(
      TextSpan(
        children: [
          if (isGroup && senderName.isNotEmpty)
            TextSpan(
              text: '$senderName: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          TextSpan(
            text: preview,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
