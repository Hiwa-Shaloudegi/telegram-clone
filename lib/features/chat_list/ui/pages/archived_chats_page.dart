import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/contact_name_map_provider.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/chat_selection_state.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chat_selection_app_bar.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chat_tile.dart';

/// Full-screen list of archived chats — same tiles/selection as the main list.
class ArchivedChatsPage extends ConsumerWidget {
  const ArchivedChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchUserChatsState = ref.watch(watchUserChatsQueryProvider);
    final contactNameMap = ref.watch(contactNameMapProvider);
    final selectionActive = ref.watch(chatSelectionActiveProvider);

    return PopScope(
      canPop: !selectionActive,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(chatSelectionProvider.notifier).clear();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: selectionActive
            ? const ChatSelectionAppBar()
            : AppBar(
                title: const Text('Archived Chats'),
                scrolledUnderElevation: 0,
              ),
        body: watchUserChatsState.when(
          data: (chats) {
            final archived = _prepareArchived(chats, contactNameMap);
            if (archived.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No archived chats',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: archived.length,
              itemBuilder: (context, index) {
                return ChatTile(item: archived[index]);
              },
            );
          },
          error: (error, _) => Center(
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<ChatListItemModel> _prepareArchived(
    List<ChatListItemModel> chats,
    Map<String, String> contactNameMap,
  ) {
    final withNames = chats.where((c) => c.isArchived).map((chat) {
      if (chat.chatType == ChatType.private &&
          chat.otherUserId != null &&
          chat.contactName == null) {
        final name = contactNameMap[chat.otherUserId];
        if (name != null) return chat.copyWith(contactName: name);
      }
      return chat;
    }).toList();

    // Keep relative order from the stream (typically last-activity first).
    // Pinned is cleared on archive, so no pin sort needed.
    return withNames;
  }
}
