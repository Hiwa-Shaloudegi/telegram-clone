import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/app/router/extra/edit_folder_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/api/chat_folders/chat_folders_api.dart';
import 'package:telegram_clone/data/models/chat_folder_model.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/contact_name_map_provider.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/folders/notifiers/command/create_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/delete_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/remove_chat_from_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/rename_folder_command.dart';
import 'package:telegram_clone/features/folders/notifiers/command/set_folder_chats_command.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';
import 'package:telegram_clone/features/folders/ui/widgets/folder_chat_tile.dart';

/// Create or edit a single folder (name + included chats).
class EditFolderPage extends ConsumerStatefulWidget {
  final String? folderId;
  final List<String> initialChatIds;

  const EditFolderPage({
    super.key,
    this.folderId,
    this.initialChatIds = const [],
  });

  bool get isCreating => folderId == null;

  @override
  ConsumerState<EditFolderPage> createState() => _EditFolderPageState();
}

class _EditFolderPageState extends ConsumerState<EditFolderPage> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isCreating) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialChatIds.isNotEmpty) {
          ref
              .read(editFolder_chatIdsProvider.notifier)
              .set(widget.initialChatIds.toSet());
        }
        _nameFocus.requestFocus();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryInitialize();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _tryInitialize() {
    if (_initialized || widget.folderId == null) return;
    final folders = ref.read(watchFoldersQueryProvider).asData?.value;
    final folder = folders?.where((f) => f.id == widget.folderId).firstOrNull;
    if (folder == null) return;
    _nameController.text = folder.name;
    ref.read(editFolder_nameProvider.notifier).set(folder.name);
    ref.read(editFolder_chatIdsProvider.notifier).set(folder.chatIds.toSet());
    _initialized = true;
  }

  Set<String> _currentChatIds() {
    if (!widget.isCreating && widget.folderId != null) {
      final folders = ref.read(watchFoldersQueryProvider).asData?.value;
      final folder = folders?.where((f) => f.id == widget.folderId).firstOrNull;
      if (folder != null) return folder.chatIds.toSet();
    }
    return ref.read(editFolder_chatIdsProvider);
  }

  List<ChatListItemModel> _resolveChats(List<ChatListItemModel> allChats) {
    final contactNames = ref.read(contactNameMapProvider);
    final chatIds = _currentChatIds();
    final byId = {for (final c in allChats) c.chatId: c};
    final result = <ChatListItemModel>[];
    for (final id in chatIds) {
      final chat = byId[id];
      if (chat == null) continue;
      if (chat.chatType == ChatType.private &&
          chat.otherUserId != null &&
          chat.contactName == null) {
        final name = contactNames[chat.otherUserId];
        result.add(name != null ? chat.copyWith(contactName: name) : chat);
      } else {
        result.add(chat);
      }
    }
    return result;
  }

  Future<void> _onAddChats() async {
    final chatIds = _currentChatIds();
    final result = await context.pushNamed<List<String>>(
      RouteNames.addChatsToFolder,
      extra: AddChatsToFolderExtra(
        selectedChatIds: chatIds.toList(),
        folderId: widget.isCreating ? null : widget.folderId,
      ),
    );

    if (!mounted) return;
    if (result != null) {
      ref.read(editFolder_chatIdsProvider.notifier).set(result.toSet());
    }
  }

  Future<void> _confirmRemoveChat(ChatListItemModel chat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Remove chat'),
          content: Text('Remove "${chat.displayTitle}" from this folder?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Remove',
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    if (!widget.isCreating && widget.folderId != null) {
      try {
        await ref
            .read(removeChatFromFolderCommandProvider.notifier)
            .run(folderId: widget.folderId!, chatId: chat.chatId);
      } catch (e) {
        if (mounted) {
          AppSnackbar.showError(context, e.toString());
        }
      }
    } else {
      final chatIds = ref.read(editFolder_chatIdsProvider);
      ref
          .read(editFolder_chatIdsProvider.notifier)
          .set({...chatIds}..remove(chat.chatId));
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Folder name cannot be empty');
      return;
    }
    if (name.length > ChatFoldersApi.maxNameLength) {
      AppSnackbar.showError(
        context,
        'Folder name can be at most ${ChatFoldersApi.maxNameLength} characters',
      );
      return;
    }

    ref.read(editFolder_savingProvider.notifier).set(true);
    try {
      final chatIds = _currentChatIds();
      if (widget.isCreating) {
        await ref
            .read(createFolderCommandProvider.notifier)
            .run(name: name, chatIds: chatIds.toList());
        if (mounted) {
          AppSnackbar.showSuccess(context, 'Folder created');
          context.pop();
        }
      } else {
        final folderId = widget.folderId!;
        final existing = ref
            .read(watchFoldersQueryProvider)
            .asData
            ?.value
            .where((f) => f.id == folderId)
            .firstOrNull;

        if (existing == null || existing.name != name) {
          await ref
              .read(renameFolderCommandProvider.notifier)
              .run(folderId: folderId, name: name);
        }

        final currentIds = existing?.chatIds.toSet() ?? {};
        if (!_setEquals(currentIds, chatIds)) {
          await ref
              .read(setFolderChatsCommandProvider.notifier)
              .run(folderId: folderId, chatIds: chatIds.toList());
        }

        if (mounted) {
          AppSnackbar.showSuccess(context, 'Folder saved');
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) ref.read(editFolder_savingProvider.notifier).set(false);
    }
  }

  Future<void> _delete() async {
    if (widget.folderId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete folder'),
        content: const Text(
          'Are you sure you want to delete this folder? '
          'Chats will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    ref.read(editFolder_savingProvider.notifier).set(true);
    try {
      await ref
          .read(deleteFolderCommandProvider.notifier)
          .run(widget.folderId!);
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Folder deleted');
        context.pop();
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) ref.read(editFolder_savingProvider.notifier).set(false);
    }
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<ChatFolderModel>>>(watchFoldersQueryProvider, (
      prev,
      next,
    ) {
      _tryInitialize();
    });

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final saving = ref.watch(editFolder_savingProvider);
    final nameLen = ref.watch(editFolder_nameProvider).length;
    ref.watch(editFolder_chatIdsProvider);
    final chatsAsync = ref.watch(watchUserChatsQueryProvider);
    final folderChats = chatsAsync.asData != null
        ? _resolveChats(chatsAsync.asData!.value)
        : <ChatListItemModel>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCreating ? 'New Folder' : 'Edit Folder'),
        actions: [
          if (!widget.isCreating)
            IconButton(
              tooltip: 'Delete folder',
              icon: const Icon(Icons.delete_outline),
              onPressed: saving ? null : _delete,
            ),
          TextButton(
            onPressed: saving ? null : _save,
            child: saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'SAVE',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Folder name',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              maxLength: ChatFoldersApi.maxNameLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Folder Name',
                counterText: '$nameLen/${ChatFoldersApi.maxNameLength}',
                border: const UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              onChanged: (v) =>
                  ref.read(editFolder_nameProvider.notifier).set(v),
            ),
          ),
          const Divider(thickness: 8, height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              'Included chats',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
              child: Icon(Icons.add, color: colorScheme.primary),
            ),
            title: Text(
              'Add Chats',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: _onAddChats,
          ),
          if (folderChats.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Text(
                'No chats in this folder yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (final chat in folderChats)
              FolderChatTile(chat: chat, onTap: () => _confirmRemoveChat(chat)),
        ],
      ),
    );
  }
}
