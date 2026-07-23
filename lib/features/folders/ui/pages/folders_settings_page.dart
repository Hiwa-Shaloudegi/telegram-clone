import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

/// Settings → Folders: list existing folders and create new ones.
class FoldersSettingsPage extends ConsumerWidget {
  const FoldersSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(watchFoldersQueryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: foldersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              e.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ),
        data: (folders) => ListView(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Create folders for different groups of chats and quickly '
                'switch between them.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.add, color: colorScheme.primary),
              ),
              title: Text(
                'Create New Folder',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => context.pushNamed(RouteNames.createFolder),
            ),
            if (folders.isNotEmpty) ...[
              const Divider(thickness: 8, height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Folders',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              for (final folder in folders) _FolderListTile(folder: folder),
            ],
          ],
        ),
      ),
    );
  }
}

class _FolderListTile extends StatelessWidget {
  final ChatFolderModel folder;

  const _FolderListTile({required this.folder});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final count = folder.chatCount;

    return ListTile(
      leading: Icon(Icons.folder_outlined, color: colorScheme.onSurfaceVariant),
      title: Text(folder.name),
      subtitle: Text(
        count == 0 ? 'No chats' : '$count chat${count == 1 ? '' : 's'}',
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.pushNamed(
        RouteNames.editFolder,
        pathParameters: {'folderId': folder.id},
      ),
    );
  }
}
