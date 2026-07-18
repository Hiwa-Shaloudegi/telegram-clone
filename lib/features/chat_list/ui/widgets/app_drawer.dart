import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/constants/app_links.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/features/chat_list/notifiers/query/watch_user_chats_query.dart';
import 'package:telegram_clone/features/chat_list/notifiers/ui/main_ui_state.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/drawer_headerd.dart';
import 'package:telegram_clone/features/chat_list/ui/widgets/drawer_item_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _openSavedMessages(BuildContext context, WidgetRef ref) {
    final chats = ref.read(watchUserChatsQueryProvider).value;
    final saved = chats
        ?.where((c) => c.chatType == ChatType.saved)
        .firstOrNull;

    if (saved == null) {
      AppSnackbar.showError(
        context,
        'No saved messages yet. Save a message to start.',
      );
      return;
    }

    ref.read(mainUi_selectedChatItemProviderProvider.notifier).set(saved);
    Navigator.pop(context);
    context.pushNamed(
      RouteNames.chat,
      pathParameters: {'chatId': saved.chatId},
      extra: saved,
    );
  }

  Future<void> _openGithub(BuildContext context) async {
    final uri = Uri.parse(AppLinks.githubRepo);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      AppSnackbar.showError(context, 'Could not open the repository.');
    }
  }

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

              Consumer(
                builder: (context, ref, _) => DrawerItemTile(
                  title: 'Saved Messages',
                  icon: Icons.bookmark_outline,
                  onTap: () => _openSavedMessages(context, ref),
                ),
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
                onTap: () => _openGithub(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
