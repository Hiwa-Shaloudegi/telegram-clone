import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/eager_initialization.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/contact_name_map_provider.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/chat_selection_state.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/app_drawer.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/archived_chats_tile.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chat_selection_app_bar.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chat_tile.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chats_app_bar_title.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/chats_empty_state.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_contacts_query.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';
import 'package:telegram_clone/features/folders/notifiers/query/watch_folders_query.dart';
import 'package:telegram_clone/features/folders/notifiers/ui/folders_ui_state.dart';
import 'package:telegram_clone/features/folders/ui/widgets/folder_tabs.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    final isFabVisible = ref.read(mainUi_isFabVisibleProvider);
    if (direction == ScrollDirection.reverse && isFabVisible) {
      ref.read(mainUi_isFabVisibleProvider.notifier).set(false);
    } else if (direction == ScrollDirection.forward && !isFabVisible) {
      ref.read(mainUi_isFabVisibleProvider.notifier).set(true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchUserChatsState = ref.watch(watchUserChatsQueryProvider);
    final contactNameMap = ref.watch(contactNameMapProvider);

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    final selectionActive = ref.watch(chatSelectionActiveProvider);

    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final folders = ref.watch(watchFoldersQueryProvider).asData?.value ?? [];

    return EagerInitialization(
      providers: [
        userProfileQueryProvider,
        getContactsQueryProvider,
        contactsUi_sortByProvider,
        watchFoldersQueryProvider,
      ],
      child: PopScope(
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
                  title: const ChatsAppBarTitle(),
                  scrolledUnderElevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                      tooltip: 'Search',
                    ),
                  ],
                ),
          drawer: AppDrawer(),
          body: Column(
            children: [
              if (!selectionActive) const FolderTabs(),
              Expanded(
                child: watchUserChatsState.when(
                  data: (chats) {
                    if (chats.isEmpty) return ChatsEmptyState();

                    final withContactNames = chats.map((chat) {
                      if (chat.chatType == ChatType.private &&
                          chat.otherUserId != null &&
                          chat.contactName == null) {
                        final name = contactNameMap[chat.otherUserId];
                        if (name != null) {
                          return chat.copyWith(contactName: name);
                        }
                      }
                      return chat;
                    }).toList();

                    // Filter by selected folder when not on "All".
                    final folderFiltered = selectedFolderId == null
                        ? withContactNames
                        : withContactNames.where((c) {
                            final folder = folders
                                .where((f) => f.id == selectedFolderId)
                                .firstOrNull;
                            if (folder == null) return false;
                            return folder.chatIds.contains(c.chatId);
                          }).toList();

                    final archived = folderFiltered
                        .where((c) => c.isArchived)
                        .toList();
                    final active = folderFiltered
                        .where((c) => !c.isArchived)
                        .toList()
                      ..sort((a, b) {
                        if (a.isPinned && !b.isPinned) return -1;
                        if (!a.isPinned && b.isPinned) return 1;
                        return 0;
                      });

                    // On a custom folder, don't surface the archive row —
                    // Telegram only shows archived under All.
                    final showArchive =
                        selectedFolderId == null && archived.isNotEmpty;

                    if (active.isEmpty && !showArchive) {
                      if (selectedFolderId != null) {
                        return const _FolderEmptyState();
                      }
                      return ChatsEmptyState();
                    }
                    if (active.isEmpty && showArchive) {
                      return ListView(
                        controller: _scrollController,
                        children: [
                          ArchivedChatsTile(archivedChats: archived),
                        ],
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: active.length + (showArchive ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (showArchive && index == 0) {
                          return ArchivedChatsTile(archivedChats: archived);
                        }
                        final item =
                            active[index - (showArchive ? 1 : 0)];
                        return ChatTile(item: item);
                      },
                    );
                  },
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                  // TODO: Replace with shimmer effect
                  loading: () => _ChatListSkeleton(),
                ),
              ),
            ],
          ),
          floatingActionButton: Consumer(
            builder: (_, ref, _) {
              final isFabVisible = ref.watch(mainUi_isFabVisibleProvider);
              return AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: isFabVisible ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isFabVisible ? 1 : 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.contacts,
                        extra: ContactsPageExtra(isOnlyAddContacts: false),
                      );
                    },
                    tooltip: 'New Message',
                    child: const Icon(Icons.edit_outlined),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FolderEmptyState extends StatelessWidget {
  const _FolderEmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No chats in this folder',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Long press a folder tab and choose Edit Folder\nto add chats.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, i) => const _SkeletonTile(),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: base, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 40,
                      height: 11,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// class _EagerInitialization extends ConsumerWidget {
//   const _EagerInitialization({required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(userProfileQueryProvider);
    // ref.watch(getContactsQueryProvider);
    // ref.watch(contactsUi_sortByProvider);
//     // ref.watch(mainUi_selectedChatItemProviderProvider);

//     return child;
//   }
// }

