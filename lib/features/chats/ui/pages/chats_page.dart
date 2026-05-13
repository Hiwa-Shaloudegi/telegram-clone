// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/notifiers/query/get_user_chats_query.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';
import 'package:telegram_clone/features/chats/ui/widgets/drawer_headerd.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.orange : Colors.blue,
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C...
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text("Chat ${index + 1}"),
              subtitle: const Text("Last message preview..."),
              trailing: Text("10:${index.toString().padLeft(2, '0')} AM"),
            );
          },
        ),

        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
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
