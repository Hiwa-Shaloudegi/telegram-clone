// lib/features/chats/ui/pages/chats_page.dart
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/notifiers/query/get_user_chats_query.dart';
import 'package:telegram_clone/features/chats/notifiers/ui/chats_ui_state.dart';
import 'package:telegram_clone/features/chats/ui/widgets/app_drawer.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chat_avatar.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    final isFabVisible = ref.read(chatsUi_isFabVisibleProvider);
    if (direction == ScrollDirection.reverse && isFabVisible) {
      ref.read(chatsUi_isFabVisibleProvider.notifier).set(false);
    } else if (direction == ScrollDirection.forward && !isFabVisible) {
      ref.read(chatsUi_isFabVisibleProvider.notifier).set(true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUserChatsState = ref.watch(getUserChatsQueryProvider);

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const ChatsAppBarTitle(),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: getUserChatsState.when(
        data: (chats) => chats.isEmpty
            ? _EmptyState()
            : ListView.builder(
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final item = chats[index];
                  return _ChatTile(item: item);
                },
              ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        loading: () => _ChatListSkeleton(),
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          final isFabVisible = ref.watch(chatsUi_isFabVisibleProvider);
          return AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: isFabVisible ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isFabVisible ? 1 : 0,
              child: FloatingActionButton(
                onPressed: () {
                  context.pushNamed(
                    RouteNames.contacts,
                    extra: ContactsPageExtra(isOnlyAddContacts: false),
                  );
                },
                tooltip: 'New Message',
                child: const Icon(Icons.edit_outlined),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Single chat tile
// ─────────────────────────────────────────────────────────────

class _ChatTile extends ConsumerWidget {
  final ChatListItemModel item;
  const _ChatTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () {
        // Mark as read then navigate
        ref.read(chatsApiProvider).markChatRead(item.chatId);
        context.pushNamed(
          RouteNames.chat,
          pathParameters: {'chatId': item.chatId},
          extra: item,
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
                      Expanded(child: _LastMessageRow(item: item)),
                      const SizedBox(width: 8),
                      if (item.unreadCount > 0)
                        _UnreadBadge(
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
    if (now.difference(dt).inDays < 7)
      return DateFormat('EEE').format(dt.toLocal());
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

// ─────────────────────────────────────────────────────────────
// Last message row (shows sender name prefix in groups)
// ─────────────────────────────────────────────────────────────

class _LastMessageRow extends StatelessWidget {
  final ChatListItemModel item;
  const _LastMessageRow({required this.item});

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

// ─────────────────────────────────────────────────────────────
// Unread badge
// ─────────────────────────────────────────────────────────────

class _UnreadBadge extends StatelessWidget {
  final int count;
  final bool muted;
  const _UnreadBadge({required this.count, required this.muted});

  @override
  Widget build(BuildContext context) {
    final color = muted
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primary;
    final textColor = muted
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onPrimary;

    final label = count > 999 ? '999+' : count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation by tapping the edit button',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────

class _ChatListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, i) => const _SkeletonTile(),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: base, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 40,
                      height: 11,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
