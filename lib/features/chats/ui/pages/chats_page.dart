// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/notifiers/query/get_user_chats_query.dart';
import 'package:telegram_clone/features/chats/notifiers/ui/chats_ui_state.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';
import 'package:telegram_clone/features/chats/ui/widgets/drawer_headerd.dart';

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
    final logoutState = ref.watch(logoutCommandProvider);

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
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                AppDrawerHeader(),
                DrawerItemTile(
                  title: 'My Profile',
                  icon: Icons.account_circle_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.profile);
                  },
                ),
                const Divider(),
                DrawerItemTile(
                  title: 'New Group',
                  icon: Icons.group_add_outlined,
                ),
                DrawerItemTile(
                  title: 'Contacts',
                  icon: Icons.contacts_outlined,
                ),

                DrawerItemTile(
                  title: 'Saved Messages',
                  icon: Icons.bookmark_outline,
                ),

                DrawerItemTile(
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.settings);
                  },
                ),
                const Divider(),
                DrawerItemTile(
                  title: 'Invite Friends',
                  icon: Icons.person_add_outlined,
                  onTap: () {},
                ),
                DrawerItemTile(
                  title: 'Github',
                  icon: Icons.code,
                  onTap: () {
                    // TODO: Add repo link
                  },
                ),
                const Divider(),
                DrawerItemTile(
                  title: 'Logout',
                  icon: Icons.logout,
                  foregroundColor: Colors.red,
                  trailing: logoutState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  onTap: logoutState.isLoading
                      ? null
                      : () {
                          ref.read(logoutCommandProvider.notifier).run();
                        },
                ),
              ],
            ),
          ],
        ),
      ),
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
                onPressed: () {},
                child: Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DrawerItemTile extends StatelessWidget {
  const DrawerItemTile({
    super.key,
    required this.title,
    required this.icon,
    this.foregroundColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color? foregroundColor;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: foregroundColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, color: foregroundColor),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
