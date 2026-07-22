import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';

part 'watch_folders_query.g.dart';

@riverpod
class WatchFoldersQuery extends _$WatchFoldersQuery {
  @override
  Stream<List<ChatFolderModel>> build() {
    return ref.read(chatFoldersApiProvider).watchFolders();
  }

  /// Optimistic local update after a mutation (before realtime catches up).
  void setLocal(List<ChatFolderModel> folders) {
    state = AsyncData(folders);
  }

  void optimisticallyRename(String folderId, String name) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData([
      for (final f in current)
        if (f.id == folderId) f.copyWith(name: name) else f,
    ]);
  }

  void optimisticallyDelete(String folderId) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.where((f) => f.id != folderId).toList());
  }

  void optimisticallyReorder(List<String> orderedIds) {
    final current = state.asData?.value;
    if (current == null) return;
    final byId = {for (final f in current) f.id: f};
    final reordered = <ChatFolderModel>[];
    for (var i = 0; i < orderedIds.length; i++) {
      final f = byId[orderedIds[i]];
      if (f != null) reordered.add(f.copyWith(position: i));
    }
    // Keep any folders missing from orderedIds at the end.
    for (final f in current) {
      if (!orderedIds.contains(f.id)) reordered.add(f);
    }
    state = AsyncData(reordered);
  }

  void optimisticallySetChatIds(String folderId, List<String> chatIds) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData([
      for (final f in current)
        if (f.id == folderId) f.copyWith(chatIds: chatIds) else f,
    ]);
  }

  void optimisticallyAddChats(String folderId, List<String> chatIds) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData([
      for (final f in current)
        if (f.id == folderId)
          f.copyWith(
            chatIds: {...f.chatIds, ...chatIds}.toList(),
          )
        else
          f,
    ]);
  }

  void optimisticallyRemoveChat(String folderId, String chatId) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData([
      for (final f in current)
        if (f.id == folderId)
          f.copyWith(
            chatIds: f.chatIds.where((id) => id != chatId).toList(),
          )
        else
          f,
    ]);
  }
}
