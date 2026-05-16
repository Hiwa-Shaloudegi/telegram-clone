import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/chats/ui/widgets/drawer_headerd.dart';
import 'package:telegram_clone/features/chats/ui/widgets/drawer_item_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                onTap: () {
                  Navigator.pop(context);
                  context.push(RouteNames.contacts);
                },
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
              Consumer(
                builder: (context, ref, _) {
                  final logoutState = ref.watch(logoutCommandProvider);
                  return DrawerItemTile(
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
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
