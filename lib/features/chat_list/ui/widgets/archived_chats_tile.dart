import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/chat_selection_state.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/unread_badge.dart';

/// Telegram-style "Archived Chats" row at the top of the main chat list.
class ArchivedChatsTile extends ConsumerWidget {
  const ArchivedChatsTile({super.key, required this.archivedChats});

  final List<ChatListItemModel> archivedChats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectionActive = ref.watch(chatSelectionActiveProvider);

    final unreadTotal = archivedChats.fold<int>(
      0,
      (sum, c) => sum + c.unreadCount,
    );
    // Preview: up to a few recent chat titles (Telegram shows names).
    final previewNames = archivedChats
        .take(3)
        .map((c) => c.displayTitle)
        .where((n) => n.isNotEmpty)
        .join(', ');

    return InkWell(
      onTap: selectionActive
          ? null
          : () => context.pushNamed(RouteNames.archivedChats),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.archive_outlined,
                color: colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Archived Chats',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (previewNames.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      previewNames,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (unreadTotal > 0) ...[
              const SizedBox(width: 8),
              UnreadBadge(count: unreadTotal, muted: true),
            ],
          ],
        ),
      ),
    );
  }
}
