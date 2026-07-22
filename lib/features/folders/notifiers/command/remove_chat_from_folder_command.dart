import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'remove_chat_from_folder_command.g.dart';

@riverpod
class RemoveChatFromFolderCommand extends _$RemoveChatFromFolderCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String folderId,
    required String chatId,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallyRemoveChat(folderId, chatId);

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).removeChatFromFolder(
            folderId: folderId,
            chatId: chatId,
          );
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}