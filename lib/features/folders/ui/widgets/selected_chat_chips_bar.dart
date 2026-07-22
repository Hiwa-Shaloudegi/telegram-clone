import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';

/// Sticky header showing "Include Chats" count + horizontal chips of selected
/// chats (avatar + name), matching Telegram's Add Chats screen.
class SelectedChatChipsBar extends StatelessWidget {
  final List<ChatListItemModel> selectedChats;
  final ValueChanged<ChatListItemModel>? onRemove;

  const SelectedChatChipsBar({
    super.key,
    required this.selectedChats,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final count = selectedChats.length;

    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              count == 0
                  ? 'Include Chats'
                  : 'Include $count Chat${count == 1 ? '' : 's'}',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (selectedChats.isNotEmpty)
            SizedBox(
              height: 86,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                itemCount: selectedChats.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final chat = selectedChats[index];
                  return _SelectedChatChip(
                    chat: chat,
                    onTap: onRemove != null ? () => onRemove!(chat) : null,
                  );
                },
              ),
            ),
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

class _SelectedChatChip extends StatelessWidget {
  final ChatListItemModel chat;
  final VoidCallback? onTap;

  const _SelectedChatChip({required this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ChatAvatar(chatInfo: chat, size: 48),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 1),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              chat.displayTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
