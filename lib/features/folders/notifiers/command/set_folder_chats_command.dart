import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'set_folder_chats_command.g.dart';

@riverpod
class SetFolderChatsCommand extends _$SetFolderChatsCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String folderId,
    required List<String> chatIds,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallySetChatIds(folderId, chatIds);

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).setFolderChats(
            folderId: folderId,
            chatIds: chatIds,
          );
    });

    link.close();
    if (state.hasError) throw state.error!;
  }
}