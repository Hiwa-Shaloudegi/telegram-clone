import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chats/notifiers/ui/chats_ui_state.dart';
import 'package:telegram_clone/features/chats/ui/widgets/app_drawer.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chat_tile.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_empty_state.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    final isFabVisible = ref.read(chatsUi_isFabVisibleProvider);
    if (direction == ScrollDirection.reverse && isFabVisible) {
      ref.read(chatsUi_isFabVisibleProvider.notifier).set(false);
    } else if (direction == ScrollDirection.forward && !isFabVisible) {
      ref.read(chatsUi_isFabVisibleProvider.notifier).set(true);
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

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
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
      body: watchUserChatsState.when(
        data: (chats) => chats.isEmpty
            ? ChatsEmptyState()
            : ListView.builder(
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final item = chats[index];
                  return ChatTile(item: item);
                },
              ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        loading: () => _ChatListSkeleton(),
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, _) {
          final isFabVisible = ref.watch(chatsUi_isFabVisibleProvider);
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
