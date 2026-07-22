import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'reorder_folders_command.g.dart';

@riverpod
class ReorderFoldersCommand extends _$ReorderFoldersCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run(List<String> orderedFolderIds) async {
    final link = ref.keepAlive();
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallyReorder(orderedFolderIds);

    state = await AsyncValue.guard(() async {
      await ref
          .read(chatFoldersApiProvider)
          .reorderFolders(orderedFolderIds);
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}