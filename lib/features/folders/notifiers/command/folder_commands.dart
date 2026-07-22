import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';

part 'folder_commands.g.dart';

@riverpod
class FolderCommands extends _$FolderCommands {
  @override
  FutureOr<void> build() {}

  Future<ChatFolderModel> createFolder({
    required String name,
    List<String> chatIds = const [],
  }) async {
    state = const AsyncLoading();
    late ChatFolderModel created;

    state = await AsyncValue.guard(() async {
      created = await ref.read(chatFoldersApiProvider).createFolder(
            name: name,
            chatIds: chatIds,
          );
      final current = ref.read(watchFoldersQueryProvider).asData?.value ?? [];
      ref.read(watchFoldersQueryProvider.notifier).setLocal([
        ...current,
        created,
      ]);
    });

    if (state.hasError) throw state.error!;
    return created;
  }

  Future<void> renameFolder({
    required String folderId,
    required String name,
  }) async {
    state = const AsyncLoading();
    final notifier = ref.read(watchFoldersQueryProvider.notifier);
    notifier.optimisticallyRename(folderId, name.trim());

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).updateFolderName(
            folderId: folderId,
            name: name,
          );
    });

    if (state.hasError) throw state.error!;
  }

  Future<void> deleteFolder(String folderId) async {
    state = const AsyncLoading();
    final selected = ref.read(selectedFolderIdProvider);
    ref.read(watchFoldersQueryProvider.notifier).optimisticallyDelete(folderId);
    if (selected == folderId) {
      ref.read(selectedFolderIdProvider.notifier).selectAll();
    }

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).deleteFolder(folderId);
    });

    if (state.hasError) throw state.error!;
  }

  Future<void> reorderFolders(List<String> orderedFolderIds) async {
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallyReorder(orderedFolderIds);

    state = await AsyncValue.guard(() async {
      await ref
          .read(chatFoldersApiProvider)
          .reorderFolders(orderedFolderIds);
    });

    if (state.hasError) throw state.error!;
  }

  Future<void> addChatsToFolder({
    required String folderId,
    required List<String> chatIds,
  }) async {
    if (chatIds.isEmpty) return;
    state = const AsyncLoading();
    ref
        .read(watchFoldersQueryProvider.notifier)
        .optimisticallyAddChats(folderId, chatIds);

    state = await AsyncValue.guard(() async {
      await ref.read(chatFoldersApiProvider).addChatsToFolder(
            folderId: folderId,
            chatIds: chatIds,
          );
    });

    if (state.hasError) throw state.error!;
  }

  Future<void> removeChatFromFolder({
    required String folderId,
    required String chatId,
  }) async {
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

    if (state.hasError) throw state.error!;
  }

  Future<void> setFolderChats({
    required String folderId,
    required List<String> chatIds,
  }) async {
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

    if (state.hasError) throw state.error!;
  }
}
