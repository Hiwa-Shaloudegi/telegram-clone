import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/core/utils/get_color_from_name.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

class ChatAvatar extends ConsumerWidget {
  const ChatAvatar({super.key, required this.chatInfo, this.size = 36});

  final ChatListItemModel chatInfo;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bg = chatInfo.chatType == ChatType.saved
        ? Colors.blue
        : getColorFromName(chatInfo.displayTitle);

    if (chatInfo.avatarUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(chatInfo.avatarUrl!),
        backgroundColor: bg,
      );
    }
    return CircleAvatar(
      radius: size / 2,
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
