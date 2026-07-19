import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/chat_selection_state.dart';

enum _SelectionMenuAction { pin, unpin, addToFolder, markUnread, blockUser }

class ChatSelectionAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const ChatSelectionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(chatSelectionProvider);
    final count = selection.length;
    final allPinned = ref.watch(chatSelectionAllPinnedProvider);
    final allArchived = ref.watch(chatSelectionAllArchivedProvider);
    final onlyDms = ref.watch(chatSelectionOnlyDmsProvider);

    void clearSelection() =>
        ref.read(chatSelectionProvider.notifier).clear();

    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel',
        onPressed: clearSelection,
      ),
      title: Text('$count'),
      actions: [
        IconButton(
          icon: Icon(allArchived ? Icons.unarchive : Icons.archive_outlined),
          tooltip: allArchived ? 'Unarchive' : 'Archive',
          onPressed: () {
            final ids = selection.keys.toList();
            ref
                .read(chatsApiProvider)
                .setArchivedForChats(ids, archive: !allArchived);
            clearSelection();
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete',
          onPressed: () => _confirmDelete(context, ref, count),
        ),
        PopupMenuButton<_SelectionMenuAction>(
          icon: const Icon(Icons.more_vert),
          onSelected: (action) =>
              _onMenuSelected(context, ref, action, allPinned),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: allPinned
                  ? _SelectionMenuAction.unpin
                  : _SelectionMenuAction.pin,
              child: Row(
                children: [
                  Icon(allPinned ? Icons.push_pin_outlined : Icons.push_pin),
                  const SizedBox(width: 12),
                  Text(allPinned ? 'Unpin' : 'Pin'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _SelectionMenuAction.addToFolder,
              child: Row(
                children: [
                  Icon(Icons.create_new_folder_outlined),
                  SizedBox(width: 12),
                  Text('Add to folder'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _SelectionMenuAction.markUnread,
              child: Row(
                children: [
                  Icon(Icons.mark_chat_unread_outlined),
                  SizedBox(width: 12),
                  Text('Mark as unread'),
                ],
              ),
            ),
            if (onlyDms)
              const PopupMenuItem(
                value: _SelectionMenuAction.blockUser,
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Block user', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _onMenuSelected(
    BuildContext context,
    WidgetRef ref,
    _SelectionMenuAction action,
    bool allPinned,
  ) {
    final selection = ref.read(chatSelectionProvider);
    final ids = selection.keys.toList();
    final notifier = ref.read(chatSelectionProvider.notifier);

    switch (action) {
      case _SelectionMenuAction.pin:
        final chats = ref.read(watchUserChatsQueryProvider).asData?.value ?? [];
        final alreadyPinned = chats.where((c) => c.isPinned).length;
        final newPins = ids.where((id) {
          final item = selection[id];
          return item != null && !item.isPinned;
        }).length;
        if (alreadyPinned + newPins > 5) {
          AppSnackbar.show(
            context,
            message: 'You can pin a maximum of 5 chats',
          );
          return;
        }
        ref
            .read(watchUserChatsQueryProvider.notifier)
            .optimisticallyTogglePin(ids, pin: true);
        ref.read(chatsApiProvider).setPinnedForChats(ids, pin: true);
        notifier.clear();
      case _SelectionMenuAction.unpin:
        ref
            .read(watchUserChatsQueryProvider.notifier)
            .optimisticallyTogglePin(ids, pin: false);
        ref.read(chatsApiProvider).setPinnedForChats(ids, pin: false);
        notifier.clear();
      case _SelectionMenuAction.addToFolder:
        AppSnackbar.show(context, message: 'Folders are coming soon');
      case _SelectionMenuAction.markUnread:
        AppSnackbar.show(context, message: 'Mark as unread is coming soon');
      case _SelectionMenuAction.blockUser:
        AppSnackbar.show(context, message: 'Block user is coming soon');
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int count) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(count == 1 ? 'Delete chat' : 'Delete $count chats'),
        content: Text(
          count == 1
              ? 'Are you sure you want to delete this chat?'
              : 'Are you sure you want to delete these chats?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(chatSelectionProvider.notifier).clear();
              AppSnackbar.show(context, message: 'Delete is coming soon');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
