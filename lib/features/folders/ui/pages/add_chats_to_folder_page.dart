import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/app/router/extra/edit_folder_extra.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/contact_name_map_provider.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/folders/notifiers/command/folder_commands.dart';
import 'package:telegram_clone/features/folders/ui/widgets/folder_chat_tile.dart';
import 'package:telegram_clone/features/folders/ui/widgets/selected_chat_chips_bar.dart';

/// Multi-select all chats to include in a folder.
///
/// Sticky "Include Chats" header with chips of selected chats (avatar + name).
/// FAB with check icon confirms the selection.
class AddChatsToFolderPage extends ConsumerStatefulWidget {
  final AddChatsToFolderExtra extra;

  const AddChatsToFolderPage({super.key, required this.extra});

  @override
  ConsumerState<AddChatsToFolderPage> createState() =>
      _AddChatsToFolderPageState();
}

class _AddChatsToFolderPageState extends ConsumerState<AddChatsToFolderPage> {
  late Set<String> _selected;
  final _searchController = TextEditingController();
  String _query = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.extra.selectedChatIds.toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatListItemModel> _withContactNames(List<ChatListItemModel> chats) {
    final map = ref.read(contactNameMapProvider);
    return chats.map((chat) {
      if (chat.chatType == ChatType.private &&
          chat.otherUserId != null &&
          chat.contactName == null) {
        final name = map[chat.otherUserId];
        if (name != null) return chat.copyWith(contactName: name);
      }
      return chat;
    }).toList();
  }

  void _toggle(ChatListItemModel chat) {
    setState(() {
      if (_selected.contains(chat.chatId)) {
        _selected.remove(chat.chatId);
      } else {
        _selected.add(chat.chatId);
      }
    });
  }

  Future<void> _confirm(List<ChatListItemModel> allChats) async {
    final ids = _selected.toList();

    // Persist when editing an existing folder.
    if (widget.extra.folderId != null) {
      setState(() => _saving = true);
      try {
        await ref.read(folderCommandsProvider.notifier).setFolderChats(
              folderId: widget.extra.folderId!,
              chatIds: ids,
            );
        if (mounted) context.pop(ids);
      } catch (e) {
        if (mounted) AppSnackbar.showError(context, e.toString());
      } finally {
        if (mounted) setState(() => _saving = false);
      }
      return;
    }

    context.pop(ids);
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(watchUserChatsQueryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chats'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_selected.isEmpty ? 56 : 150),
          child: chatsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (chats) {
              final withNames = _withContactNames(chats);
              final byId = {for (final c in withNames) c.chatId: c};
              final selectedChats = _selected
                  .map((id) => byId[id])
                  .whereType<ChatListItemModel>()
                  .toList();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectedChatChipsBar(
                    selectedChats: selectedChats,
                    onRemove: (chat) => _toggle(chat),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saving
            ? null
            : () {
                final chats = chatsAsync.asData?.value ?? [];
                _confirm(chats);
              },
        tooltip: 'Confirm',
        child: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: chatsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (chats) {
                final withNames = _withContactNames(chats)
                    .where((c) => !c.isArchived)
                    .toList()
                  ..sort((a, b) {
                    if (a.isPinned && !b.isPinned) return -1;
                    if (!a.isPinned && b.isPinned) return 1;
                    return 0;
                  });

                final filtered = _query.isEmpty
                    ? withNames
                    : withNames
                        .where(
                          (c) =>
                              c.displayTitle.toLowerCase().contains(_query),
                        )
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No chats found'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final chat = filtered[index];
                    final selected = _selected.contains(chat.chatId);
                    return FolderChatTile(
                      chat: chat,
                      selected: selected,
                      showCheck: true,
                      onTap: () => _toggle(chat),
                      trailing: selected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: theme.colorScheme.outline,
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
