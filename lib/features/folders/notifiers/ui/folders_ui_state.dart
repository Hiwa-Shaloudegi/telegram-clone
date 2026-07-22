import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folders_ui_state.g.dart';

/// `null` means the built-in "All" tab is selected.
@riverpod
class SelectedFolderId extends _$SelectedFolderId {
  @override
  String? build() => null;

  void selectAll() => state = null;

  void select(String? folderId) => state = folderId;
}
