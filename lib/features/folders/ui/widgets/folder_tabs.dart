import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
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

    return foldersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (folders) {
        if (folders.isEmpty) return const SizedBox.shrink();
        return _FolderTabsBar(folders: folders);
      },
    );
  }
}

class _FolderTabsBar extends ConsumerWidget {
  final List<ChatFolderModel> folders;

  const _FolderTabsBar({required this.folders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedId = ref.watch(selectedFolderIdProvider);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Match Telegram tab strip under the blue/dark app bar.
    final barColor = isDark
        ? const Color(0xFF17212B)
        : theme.appBarTheme.backgroundColor ?? colorScheme.primary;
    final selectedColor = Colors.white;
    final unselectedColor = Colors.white.withValues(alpha: 0.7);
    final indicatorColor = Colors.white;

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
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              indicatorColor: indicatorColor,
              onTap: () =>
                  ref.read(selectedFolderIdProvider.notifier).selectAll(),
            ),
            for (final folder in folders)
              _FolderTab(
                label: folder.name,
                isSelected: selectedId == folder.id,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                indicatorColor: indicatorColor,
                onTap: () => ref
                    .read(selectedFolderIdProvider.notifier)
                    .select(folder.id),
                onLongPress: () => _onFolderLongPress(context, ref, folder),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onFolderLongPress(
    BuildContext context,
    WidgetRef ref,
    ChatFolderModel folder,
  ) async {
    final action = await showFolderTabActionsSheet(context);
    if (!context.mounted || action == null) return;

    switch (action) {
      case FolderTabAction.reorder:
        context.pushNamed(RouteNames.reorderFolders);
      case FolderTabAction.editFolder:
        context.pushNamed(
          RouteNames.editFolder,
          pathParameters: {'folderId': folder.id},
        );
    }
  }
}

class _FolderTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _FolderTab({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? indicatorColor : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedColor : unselectedColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
