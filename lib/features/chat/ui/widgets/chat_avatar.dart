import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/utils/get_color_from_name.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

class ChatAvatar extends ConsumerWidget {
  const ChatAvatar({super.key, required this.chatInfo});

  final ChatListItemModel chatInfo;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bg = chatInfo.chatType == 'saved'
        ? Colors.blue
        : getColorFromName(chatInfo.displayTitle);
    if (chatInfo.avatarUrl != null) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(chatInfo.avatarUrl!),
        backgroundColor: bg,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: bg,
      child: Text(
        chatInfo.avatarInitials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
