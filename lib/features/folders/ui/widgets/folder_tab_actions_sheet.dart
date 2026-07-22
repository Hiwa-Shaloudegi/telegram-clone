import 'package:flutter/material.dart';

enum FolderTabAction { reorder, editFolder }

/// Telegram-style action sheet shown on long-press of a folder tab.
Future<FolderTabAction?> showFolderTabActionsSheet(BuildContext context) {
  return showModalBottomSheet<FolderTabAction>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.reorder,
                color: theme.colorScheme.onSurface,
              ),
              title: const Text('Reorder'),
              onTap: () => Navigator.pop(ctx, FolderTabAction.reorder),
            ),
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.onSurface,
              ),
              title: const Text('Edit Folder'),
              onTap: () => Navigator.pop(ctx, FolderTabAction.editFolder),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
