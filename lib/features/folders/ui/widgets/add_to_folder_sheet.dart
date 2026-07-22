import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/folders/notifiers/command/add_chats_to_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/remove_chat_from_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';

/// Bottom sheet to pick one or more folders when adding selected chats.
Future<void> showAddToFolderSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<String> chatIds,
}) async {
  if (chatIds.isEmpty) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (ctx) {
      return _AddToFolderSheetBody(chatIds: chatIds);
    },
  );
}

class _AddToFolderSheetBody extends ConsumerWidget {
  final List<String> chatIds;

  const _AddToFolderSheetBody({required this.chatIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(watchFoldersQueryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Add to Folder',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.create_new_folder_outlined,
                  color: colorScheme.primary),
              title: Text(
                'Create New Folder',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed(RouteNames.createFolder);
              },
            ),
            foldersAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(e.toString()),
              ),
              data: (folders) {
                if (folders.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Text(
                      'No folders yet. Create one to organize your chats.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      final alreadyAll = chatIds.every(
                        (id) => folder.chatIds.contains(id),
                      );
                      return ListTile(
                        leading: Icon(
                          Icons.folder_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        title: Text(folder.name),
                        trailing: alreadyAll
                            ? Icon(Icons.check, color: colorScheme.primary)
                            : null,
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            if (alreadyAll) {
                              for (final chatId in chatIds) {
                                await ref
                                    .read(removeChatFromFolderCommandProvider.notifier)
                                    .run(
                                      folderId: folder.id,
                                      chatId: chatId,
                                    );
                              }
                              if (context.mounted) {
                                AppSnackbar.showSuccess(
                                  context,
                                  chatIds.length == 1
                                      ? 'Chat removed from ${folder.name}'
                                      : 'Chats removed from ${folder.name}',
                                );
                              }
                            } else {
                              await ref
                                  .read(addChatsToFolderCommandProvider.notifier)
                                  .run(
                                    folderId: folder.id,
                                    chatIds: chatIds,
                                  );
                              if (context.mounted) {
                                AppSnackbar.showSuccess(
                                  context,
                                  chatIds.length == 1
                                      ? 'Chat added to ${folder.name}'
                                      : 'Chats added to ${folder.name}',
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.showError(
                                context,
                                e.toString(),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
