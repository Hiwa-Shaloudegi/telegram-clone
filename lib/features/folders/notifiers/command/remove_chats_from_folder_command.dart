import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'remove_chats_from_folder_command.g.dart';

@riverpod
class RemoveChatsFromFolderCommand extends _$RemoveChatsFromFolderCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String folderId,
    required List<String> chatIds,
  }) async {
    if (chatIds.isEmpty) return;
    final link = ref.keepAlive();
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallyRemoveChats(folderId, chatIds);

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).removeChatsFromFolder(
            folderId: folderId,
            chatIds: chatIds,
          );
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}
