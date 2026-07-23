import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/folders/notifiers/command/delete_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/reorder_folders_command.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';
import 'package:telegram_clone/features/folders/ui/widgets/folder_tab_actions_sheet.dart';

/// Horizontal folder tabs shown under the main chats AppBar (Telegram-style).
///
/// Hidden when the user has no custom folders.
class FolderTabs extends ConsumerWidget {
  const FolderTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(watchFoldersQueryProvider);
    final isReorderMode = ref.watch(reorderFolders_isActiveProvider);

    return foldersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (folders) {
        if (folders.isEmpty) return const SizedBox.shrink();
        return _FolderTabsBar(folders: folders, isReorderMode: isReorderMode);
      },
    );
  }
}

class _FolderTabsBar extends ConsumerWidget {
  final List<ChatFolderModel> folders;
  final bool isReorderMode;

  const _FolderTabsBar({required this.folders, required this.isReorderMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedId = ref.watch(selectedFolderIdProvider);
    final localFolders = ref.watch(reorderFolders_localProvider);
    final longPressedFolderId = ref.watch(folderTabs_longPressedFolderIdProvider);
    final longPressedAll = ref.watch(folderTabs_longPressedAllProvider);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Match Telegram tab strip under the blue/dark app bar.
    final barColor = isDark
        ? const Color(0xFF17212B)
        : theme.appBarTheme.backgroundColor ?? colorScheme.primary;
    final selectedColor = Colors.white;
    final unselectedColor = Colors.white.withValues(alpha: 0.7);
    final indicatorColor = Colors.white;

    // Slight background highlight for long-pressed tab.
    final longPressHighlight = Colors.white.withValues(alpha: 0.12);

    // Use local reordered list if available, otherwise use original
    final displayFolders = localFolders ?? folders;

    if (isReorderMode) {
      return _buildReorderMode(
        ref,
        displayFolders,
        selectedId,
        barColor,
        selectedColor,
        unselectedColor,
        indicatorColor,
      );
    }

    return Material(
      color: barColor,
      elevation: 0,
      child: SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          children: [
            _FolderTab(
              label: 'All',
              isSelected: selectedId == null,
              backgroundColor: longPressedAll ? longPressHighlight : null,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              indicatorColor: indicatorColor,
              onTap: () =>
                  ref.read(selectedFolderIdProvider.notifier).selectAll(),
              onLongPress: (renderBox) =>
                  _onTabLongPress(context, ref, renderBox, isAllFolder: true),
            ),
            for (final folder in folders)
              _FolderTab(
                label: folder.name,
                isSelected: selectedId == folder.id,
                backgroundColor: longPressedFolderId == folder.id
                    ? longPressHighlight
                    : null,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                indicatorColor: indicatorColor,
                onTap: () => ref
                    .read(selectedFolderIdProvider.notifier)
                    .select(folder.id),
                onLongPress: (renderBox) =>
                    _onTabLongPress(context, ref, renderBox, folder: folder),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderMode(
    WidgetRef ref,
    List<ChatFolderModel> folders,
    String? selectedId,
    Color barColor,
    Color selectedColor,
    Color unselectedColor,
    Color indicatorColor,
  ) {
    return Material(
      color: barColor,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reorder mode action bar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _saveReorder(ref),
                  child: Text(
                    'DONE',
                    style: TextStyle(
                      color: selectedColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Reorderable folder tabs
          SizedBox(
            height: 44,
            child: SizedBox(
              height: 44,
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                buildDefaultDragHandles: false, // <-- removes the "=" icon
                itemCount: folders.length,
                onReorder: (oldIndex, newIndex) {
                  final list = List<ChatFolderModel>.from(folders);
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = list.removeAt(oldIndex);
                  list.insert(newIndex, item);
                  ref.read(reorderFolders_localProvider.notifier).set(list);
                },
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return Row(
                    key: ValueKey(folder.id),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: _FolderTab(
                          label: folder.name,
                          isSelected: selectedId == folder.id,
                          backgroundColor: null,
                          selectedColor: selectedColor,
                          unselectedColor: unselectedColor,
                          indicatorColor: indicatorColor,
                          onTap: () {},
                          onLongPress: null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _confirmDeleteFolder(context, ref, folder),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.cancel,
                            size: 18,
                            color: unselectedColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTabLongPress(
    BuildContext context,
    WidgetRef ref,
    RenderBox tabBox, {
    ChatFolderModel? folder,
    bool isAllFolder = false,
  }) async {
    if (isAllFolder) {
      ref.read(folderTabs_longPressedAllProvider.notifier).set(true);
    } else {
      ref.read(folderTabs_longPressedFolderIdProvider.notifier).set(folder?.id);
    }

    final action = await showFolderTabActionsPopup(
      context,
      tabBox,
      isAllFolder: isAllFolder,
    );

    // Clear highlight after menu closes.
    _clearLongPress(ref);

    if (!context.mounted || action == null) return;

    switch (action) {
      case FolderTabAction.reorder:
        // Activate reorder mode directly on this page
        ref.read(reorderFolders_isActiveProvider.notifier).activate();
      case FolderTabAction.editFolder:
        if (folder != null) {
          context.pushNamed(
            RouteNames.editFolder,
            pathParameters: {'folderId': folder.id},
          );
        }
      case FolderTabAction.markAllRead:
        _markAllAsRead(context, ref, folder);
      case FolderTabAction.deleteFolder:
        if (folder != null) {
          _confirmDeleteFolder(context, ref, folder);
        }
    }
  }

  void _clearLongPress(WidgetRef ref) {
    ref.read(folderTabs_longPressedFolderIdProvider.notifier).set(null);
    ref.read(folderTabs_longPressedAllProvider.notifier).set(false);
  }

  void _saveReorder(WidgetRef ref) {
    final localFolders = ref.read(reorderFolders_localProvider);
    if (localFolders == null || localFolders.isEmpty) {
      ref.read(reorderFolders_isActiveProvider.notifier).deactivate();
      ref.read(reorderFolders_localProvider.notifier).set(null);
      return;
    }

    // Deactivate immediately for instant feedback
    ref.read(reorderFolders_isActiveProvider.notifier).deactivate();
    ref.read(reorderFolders_localProvider.notifier).set(null);

    // Fire-and-forget the API call
    ref
        .read(reorderFoldersCommandProvider.notifier)
        .run(localFolders.map((f) => f.id).toList());
  }

  void _markAllAsRead(BuildContext context, WidgetRef ref, ChatFolderModel? folder) {
    final chats = ref.read(watchUserChatsQueryProvider).asData?.value ?? [];
    final chatIds = folder != null
        ? chats
              .where((c) => folder.chatIds.contains(c.chatId))
              .map((c) => c.chatId)
              .toList()
        : chats.map((c) => c.chatId).toList();

    final unreadIds = chatIds.where((id) {
      final chat = chats.firstWhere((c) => c.chatId == id);
      return chat.unreadCount > 0;
    }).toList();

    if (unreadIds.isEmpty) {
      AppSnackbar.show(context, message: 'No unread messages');
      return;
    }

    final chatsNotifier = ref.read(watchUserChatsQueryProvider.notifier);
    for (final id in unreadIds) {
      chatsNotifier.optimisticallyMarkAsRead(id);
      ref.read(chatsApiProvider).markChatRead(id);
    }
    AppSnackbar.show(context, message: 'Marked as read');
  }

  void _confirmDeleteFolder(
    BuildContext context,
    WidgetRef ref,
    ChatFolderModel folder,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Folder'),
        content: const Text(
          'Are you sure you want to remove this folder? Your chats will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref
                    .read(deleteFolderCommandProvider.notifier)
                    .run(folder.id);
                if (context.mounted) {
                  AppSnackbar.show(
                    context,
                    message: '"${folder.name}" deleted',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  AppSnackbar.showError(context, e.toString());
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _FolderTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final VoidCallback onTap;
  final void Function(RenderBox renderBox)? onLongPress;
  final VoidCallback? onRemove;

  const _FolderTab({
    required this.label,
    required this.isSelected,
    this.backgroundColor,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
    required this.onTap,
    this.onLongPress,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();

    return InkWell(
      key: globalKey,
      onTap: onTap,
      onLongPress: onLongPress != null
          ? () {
              final box =
                  globalKey.currentContext?.findRenderObject() as RenderBox?;
              if (box != null) onLongPress!(box);
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? indicatorColor : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 4),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.cancel),
                visualDensity: VisualDensity.compact,
                iconSize: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
