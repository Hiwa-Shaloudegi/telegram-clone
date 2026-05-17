// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/notifiers/query/get_user_chats_query.dart';
import 'package:telegram_clone/features/chats/notifiers/ui/chats_ui_state.dart';
import 'package:telegram_clone/features/chats/ui/widgets/app_drawer.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      final isFabVisible = ref.read(chatsUi_isFabVisibleProvider);

      if (direction == ScrollDirection.reverse && isFabVisible) {
        ref.read(chatsUi_isFabVisibleProvider.notifier).set(false);
      } else if (direction == ScrollDirection.forward && !isFabVisible) {
        ref.read(chatsUi_isFabVisibleProvider.notifier).set(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getUserChatsState = ref.watch(getUserChatsQueryProvider);

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const ChatsAppBarTitle(),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer: AppDrawer(),
      body: getUserChatsState.when(
        data: (data) => ListView.builder(
          controller: _scrollController,
          itemCount: 20,
          itemBuilder: (context, index) {
            final chatItem = data[0];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.orange : Colors.blue,
                child: Text(
                  // String.fromCharCode(65 + index), // A, B, C...
                  chatItem.chat.title?[0] ?? 'T',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(chatItem.chat.title ?? 'title'),
              subtitle: const Text("Last message preview..."),
              // trailing: Text("10:${index.toString().padLeft(2, '0')} AM"),
              trailing: Text(chatItem.chat.updatedAt.toString()),
            );
          },
        ),

        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          final isFabVisible = ref.watch(chatsUi_isFabVisibleProvider);

          return AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: isFabVisible ? Offset.zero : const Offset(0, 1),
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
                child: Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}
