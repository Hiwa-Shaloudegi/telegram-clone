import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/drawer_headerd.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/drawer_item_tile.dart';

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
                  context.pushNamed(RouteNames.profile);
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
                  context.pushNamed(
                    RouteNames.contacts,
                    extra: ContactsPageExtra(isOnlyAddContacts: true),
                  );
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
                  context.pushNamed(RouteNames.settings);
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
            ],
          ),
        ],
      ),
    );
  }
}
