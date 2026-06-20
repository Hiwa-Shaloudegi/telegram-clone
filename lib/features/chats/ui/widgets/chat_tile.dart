import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chats/notifiers/ui/main_ui_state.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chats/ui/widgets/last_message_row.dart';
import 'package:telegram_clone/features/chats/ui/widgets/unread_badge.dart';

class ChatTile extends ConsumerWidget {
  final ChatListItemModel item;
  const ChatTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () {
        // TODO: is it necessary to mark as read here? maybe just do it in chat page when messages are loaded?
        // Mark as read then navigate
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(item);
        });
        // TODO: if it's mobile view, then navigate and select chat, else just update selected chat
        context.pushNamed(
          RouteNames.chat,
          pathParameters: {'chatId': item.chatId},
        );
      },
      onLongPress: () => _showContextMenu(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ──
            Stack(
              children: [
                ChatAvatar(
                  displayTitle: item.displayTitle,
                  imageUrl: item.avatarUrl,
                  chatType: item.chatType,
                  size: 52,
                ),
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

  void _showContextMenu(BuildContext context, WidgetRef ref) {
    final api = ref.read(chatsApiProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(
                item.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              ),
              title: Text(item.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.pop(context);
                api.togglePin(item.chatId, pin: !item.isPinned);
              },
            ),
            ListTile(
              leading: Icon(
                item.isMuted
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
              ),
              title: Text(item.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(context);
                api.toggleMute(item.chatId, mute: !item.isMuted);
              },
            ),
            ListTile(
              leading: Icon(
                item.isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
              title: Text(item.isArchived ? 'Unarchive' : 'Archive'),
              onTap: () {
                Navigator.pop(context);
                api.toggleArchive(item.chatId, archive: !item.isArchived);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
