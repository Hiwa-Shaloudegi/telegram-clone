import 'package:flutter/material.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

class ChatProfileSubtitle extends StatelessWidget {
  const ChatProfileSubtitle({super.key, required this.chatInfo});

  final ChatListItemModel chatInfo;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = (Theme.of(context).appBarTheme.foregroundColor ?? Colors.white)
        .withValues(alpha: 0.7);
    switch (chatInfo.chatType) {
      case ChatType.channel:
        return Text(
          'Channel',
          style: TextStyle(
            fontSize: 12,
            color: subtitleColor,
          ),
        );
      case ChatType.group:
        return Text(
          'Group',
          style: TextStyle(
            fontSize: 12,
            color: subtitleColor,
          ),
        );
      case ChatType.saved:
        return Text(
          'Your saved messages',
          style: TextStyle(
            fontSize: 12,
            color: subtitleColor,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
