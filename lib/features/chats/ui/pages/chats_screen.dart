import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/theme/theme_notifier.dart';
 
class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key}); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram'),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("User Name"),
              accountEmail: const Text("+1 234 567 890"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "U",
                  style: TextStyle(fontSize: 24.0, color: Colors.blue),
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Group'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Contacts'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
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
