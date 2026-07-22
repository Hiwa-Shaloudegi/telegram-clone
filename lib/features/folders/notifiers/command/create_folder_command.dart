import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

part 'create_folder_command.g.dart';

@riverpod
class CreateFolderCommand extends _$CreateFolderCommand {
  @override
  FutureOr<void> build() {}

  Future<ChatFolderModel> run({
    required String name,
    List<String> chatIds = const [],
  }) async {
    final link = ref.keepAlive();
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

    link.close();
    if (state.hasError) throw state.error!;
    return created;
  }
}