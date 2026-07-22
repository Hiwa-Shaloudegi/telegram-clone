import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'rename_folder_command.g.dart';

@riverpod
class RenameFolderCommand extends _$RenameFolderCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String folderId,
    required String name,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncLoading();
    final notifier = ref.read(watchFoldersQueryProvider.notifier);
    notifier.optimisticallyRename(folderId, name.trim());

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).updateFolderName(
            folderId: folderId,
            name: name,
          );
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}