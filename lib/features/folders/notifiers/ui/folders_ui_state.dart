import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';

part 'folders_ui_state.g.dart';

/// `null` means the built-in "All" tab is selected.
@riverpod
class SelectedFolderId extends _$SelectedFolderId {
  @override
  String? build() => null;

  void selectAll() => state = null;

  void select(String? folderId) => state = folderId;
}

// ---------------------------------------------------------------------------
// EditFolderPage state
// ---------------------------------------------------------------------------

@riverpod
class EditFolder_chatIds extends _$EditFolder_chatIds {
  @override
  Set<String> build() => const {};

  void set(Set<String> value) => state = value;

  void add(String id) => state = {...state, id};

  void remove(String id) => state = {...state}..remove(id);
}

@riverpod
class EditFolder_saving extends _$EditFolder_saving {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

@riverpod
class EditFolder_name extends _$EditFolder_name {
  @override
  String build() => '';

  void set(String value) => state = value;
}

// ---------------------------------------------------------------------------
// AddChatsToFolderPage state
// ---------------------------------------------------------------------------

@riverpod
class AddChats_selected extends _$AddChats_selected {
  @override
  Set<String> build() => const {};

  void set(Set<String> value) => state = value;

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }
}

@riverpod
class AddChats_query extends _$AddChats_query {
  @override
  String build() => '';

  void set(String value) => state = value;
}

@riverpod
class AddChats_saving extends _$AddChats_saving {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

// ---------------------------------------------------------------------------
// ReorderFoldersPage state
// ---------------------------------------------------------------------------

@riverpod
class ReorderFolders_local extends _$ReorderFolders_local {
  @override
  List<ChatFolderModel>? build() => null;

  void set(List<ChatFolderModel>? value) => state = value;
}

@riverpod
class ReorderFolders_saving extends _$ReorderFolders_saving {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
