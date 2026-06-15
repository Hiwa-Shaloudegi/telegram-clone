import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

class ChatProfileSubtitle extends StatelessWidget {
  const ChatProfileSubtitle({super.key, required this.chatInfo});

  final ChatListItemModel chatInfo;

  @override
  Widget build(BuildContext context) {
    switch (chatInfo.chatType) {
      case 'channel':
        return Text(
          'Channel',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      case 'group':
        return Text(
          'Group',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      case 'saved':
        return Text(
          'Your saved messages',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
