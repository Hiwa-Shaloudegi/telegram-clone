import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';

part 'delete_folder_command.g.dart';

@riverpod
class DeleteFolderCommand extends _$DeleteFolderCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run(String folderId) async {
    final link = ref.keepAlive();
    state = const AsyncLoading();
    final selected = ref.read(selectedFolderIdProvider);
    ref.read(watchFoldersQueryProvider.notifier).optimisticallyDelete(folderId);
    if (selected == folderId) {
      ref.read(selectedFolderIdProvider.notifier).selectAll();
    }

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).deleteFolder(folderId);
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}