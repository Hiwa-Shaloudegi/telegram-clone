import 'package:flutter/material.dart';

enum FolderTabAction { reorder, editFolder, markAllRead, deleteFolder }

/// Shows a popup menu anchored to the folder tab on long-press.
Future<FolderTabAction?> showFolderTabActionsPopup(
  BuildContext context,
  RenderBox tabBox, {
  required bool isAllFolder,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final tabPosition = tabBox.localToGlobal(Offset.zero, ancestor: overlay);
  final tabSize = tabBox.size;

  final items = <PopupMenuEntry<FolderTabAction>>[
    const PopupMenuItem(
      value: FolderTabAction.reorder,
      child: Row(
        children: [
          Icon(Icons.reorder, size: 20),
          SizedBox(width: 12),
          Text('Reorder'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: FolderTabAction.editFolder,
      child: Row(
        children: [
          Icon(Icons.edit_outlined, size: 20),
          SizedBox(width: 12),
          Text('Edit Folder'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: FolderTabAction.markAllRead,
      child: Row(
        children: [
          Icon(Icons.mark_chat_read_outlined, size: 20),
          SizedBox(width: 12),
          Text('Mark all as read'),
        ],
      ),
    ),
    if (!isAllFolder) ...[
      const PopupMenuDivider(),
      const PopupMenuItem(
        value: FolderTabAction.deleteFolder,
        child: Row(
          children: [
            Icon(Icons.delete_outline, size: 20, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete Folder', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ],
  ];

  return showMenu<FolderTabAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      tabPosition.dx,
      tabPosition.dy + tabSize.height,
      overlay.size.width - tabPosition.dx - tabSize.width,
      overlay.size.height - tabPosition.dy - tabSize.height,
    ),
    items: items,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
