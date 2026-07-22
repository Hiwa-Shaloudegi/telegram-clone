import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/folders/notifiers/command/folder_commands.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

/// Drag-to-reorder folders page (opened from long-press → Reorder).
class ReorderFoldersPage extends ConsumerStatefulWidget {
  const ReorderFoldersPage({super.key});

  @override
  ConsumerState<ReorderFoldersPage> createState() => _ReorderFoldersPageState();
}

class _ReorderFoldersPageState extends ConsumerState<ReorderFoldersPage> {
  List<ChatFolderModel>? _local;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(watchFoldersQueryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final folders = _local ?? foldersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Folders'),
        actions: [
          TextButton(
            onPressed: _saving || folders.isEmpty
                ? null
                : () => _save(folders),
            child: _saving
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
              setState(() {
                final list = List<ChatFolderModel>.from(folders);
                if (newIndex > oldIndex) newIndex -= 1;
                final item = list.removeAt(oldIndex);
                list.insert(newIndex, item);
                _local = list;
              });
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

  Future<void> _save(List<ChatFolderModel> folders) async {
    setState(() => _saving = true);
    try {
      await ref.read(folderCommandsProvider.notifier).reorderFolders(
            folders.map((f) => f.id).toList(),
          );
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Folders reordered');
        context.pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
