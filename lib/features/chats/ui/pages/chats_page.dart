import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/theme/theme_notifier.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/ui/widgets/chats_app_bar_title.dart';
import 'package:telegram_clone/features/chats/ui/widgets/drawer_headerd.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final logoutState = ref.watch(logoutCommandProvider);

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const ChatsAppBarTitle(),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                AppDrawerHeader(),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('My Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.profile);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.group_add_outlined),
                  title: const Text('New Group'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.contacts_outlined),
                  title: const Text('Contacts'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: const Text('Saved Messages'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Invite Friends'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Github'),
                  onTap: () {
                    // TODO: Add repo link
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
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
      body: ListView.builder(
        itemCount: 15,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
