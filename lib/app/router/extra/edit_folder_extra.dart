/// Extra payload for the create/edit folder route.
///
/// When [folderId] is null the page runs in "create folder" mode.
class EditFolderExtra {
  final String? folderId;
  final String? initialName;
  final List<String> initialChatIds;

  const EditFolderExtra({
    this.folderId,
    this.initialName,
    this.initialChatIds = const [],
  });

  bool get isCreating => folderId == null;
}

/// Extra payload for the multi-select "Add Chats" page.
class AddChatsToFolderExtra {
  /// Pre-selected chat IDs (already in the folder / draft).
  final List<String> selectedChatIds;

  /// When set, confirming writes directly to this folder.
  /// When null, the page returns the selection via [Navigator.pop].
  final String? folderId;

  const AddChatsToFolderExtra({
    this.selectedChatIds = const [],
    this.folderId,
  });
}
