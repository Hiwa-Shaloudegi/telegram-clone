import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/folders/notifiers/command/reorder_folders_command.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';

/// Drag-to-reorder folders page (opened from long-press → Reorder).
class ReorderFoldersPage extends ConsumerWidget {
  const ReorderFoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(watchFoldersQueryProvider);
    final local = ref.watch(reorderFolders_localProvider);
    final saving = ref.watch(reorderFolders_savingProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final folders = local ?? foldersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Folders'),
        actions: [
          TextButton(
            onPressed: saving || folders.isEmpty
                ? null
                : () => _save(context, ref, folders),
            child: saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'DONE',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: foldersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (_) {
          if (folders.isEmpty) {
            return const Center(child: Text('No folders to reorder'));
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: folders.length,
            onReorder: (oldIndex, newIndex) {
              final list = List<ChatFolderModel>.from(folders);
              if (newIndex > oldIndex) newIndex -= 1;
              final item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
              ref.read(reorderFolders_localProvider.notifier).set(list);
            },
            itemBuilder: (context, index) {
              final folder = folders[index];
              return ListTile(
                key: ValueKey(folder.id),
                leading: Icon(
                  Icons.folder_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                title: Text(folder.name),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_handle,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    List<ChatFolderModel> folders,
  ) async {
    ref.read(reorderFolders_savingProvider.notifier).set(true);
    try {
      await ref.read(reorderFoldersCommandProvider.notifier).run(
            folders.map((f) => f.id).toList(),
          );
      if (context.mounted) {
        AppSnackbar.showSuccess(context, 'Folders reordered');
        context.pop();
      }
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, e.toString());
    } finally {
      if (context.mounted) {
        ref.read(reorderFolders_savingProvider.notifier).set(false);
      }
    }
  }
}
