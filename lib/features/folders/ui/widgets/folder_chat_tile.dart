import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';

/// Compact chat row used on folder edit / add-chats screens.
class FolderChatTile extends StatelessWidget {
  final ChatListItemModel chat;
  final VoidCallback? onTap;
  final bool selected;
  final bool showCheck;
  final Widget? trailing;

  const FolderChatTile({
    super.key,
    required this.chat,
    this.onTap,
    this.selected = false,
    this.showCheck = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          ChatAvatar(chatInfo: chat, size: 46),
          if (showCheck && selected)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 1.5),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
            ),
        ],
      ),
      title: Text(
        chat.displayTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: trailing,
    );
  }
}
