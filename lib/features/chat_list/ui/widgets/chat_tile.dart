import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/chat_selection_state.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/last_message_row.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/unread_badge.dart';

class ChatTile extends ConsumerWidget {
  final ChatListItemModel item;
  const ChatTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final selectionActive = ref.watch(chatSelectionActiveProvider);
    final isSelected = ref.watch(
      chatSelectionProvider.select((s) => s.containsKey(item.chatId)),
    );

    return InkWell(
      onTap: () {
        if (selectionActive) {
          ref.read(chatSelectionProvider.notifier).toggle(item);
          return;
        }
        // TODO: is it necessary to mark as read here? maybe just do it in chat page when messages are loaded?
        // Mark as read then navigate
        ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(item);
        // TODO: if it's mobile view, then navigate and select chat, else just update selected chat
        context.pushNamed(
          RouteNames.chat,
          pathParameters: {'chatId': item.chatId},
          extra: item,
        );
      },
      onLongPress: () => ref.read(chatSelectionProvider.notifier).toggle(item),
      child: Container(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ──
            Stack(
              children: [
                ChatAvatar(chatInfo: item, size: 50),
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 26,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                // ChatAvatar(
                //   displayTitle: item.displayTitle,
                //   imageUrl: item.avatarUrl,
                //   chatType: item.chatType,
                //   size: 52,
                // ),
                if (item.isMuted)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.volume_off,
                        size: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: name + time
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (item.isPinned)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.push_pin,
                                  size: 14,
                                  color: colorScheme.primary,
                                ),
                              ),
                            Flexible(
                              child: Text(
                                item.displayTitle,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.lastMessageAt != null)
                        Text(
                          _formatTime(item.lastMessageAt!),
                          style: textTheme.bodySmall?.copyWith(
                            color: item.unreadCount > 0
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: item.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Row 2: last message + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: LastMessageRow(item: item)),
                      const SizedBox(width: 8),
                      if (item.unreadCount > 0)
                        UnreadBadge(
                          count: item.unreadCount,
                          muted: item.isMuted,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDay = DateTime(dt.year, dt.month, dt.day);

    if (msgDay == today) return DateFormat('HH:mm').format(dt.toLocal());
    if (msgDay == yesterday) return 'Yesterday';
    if (now.difference(dt).inDays < 7) {
      return DateFormat('EEE').format(dt.toLocal());
    }
    return DateFormat('dd/MM/yy').format(dt.toLocal());
  }
}
