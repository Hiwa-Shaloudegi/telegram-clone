import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/profile_info_section.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:telegram_clone/features/settings/ui/widgets/menu_item.dart';
import 'package:telegram_clone/features/settings/ui/widgets/profile_header.dart';
import 'package:telegram_clone/features/settings/ui/widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileQueryProvider);
    final logoutState = ref.watch(logoutCommandProvider);

    return AppScaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          PopupMenuButton<ProfileMenuAction>(
            onSelected: (action) {
              switch (action) {
                case ProfileMenuAction.editInfo:
                  context.pushNamed(RouteNames.editProfile);
                  break;
                case ProfileMenuAction.setPhoto:
                  AppSnackbar.showSuccess(
                    context,
                    'Set profile photo (Coming Soon)',
                  );
                  break;
                case ProfileMenuAction.changeUsername:
                  AppSnackbar.showSuccess(
                    context,
                    'Change username (Coming Soon)',
                  );
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: ProfileMenuAction.editInfo,
                child: MenuItem(icon: Icons.edit, text: 'Edit info'),
              ),
              PopupMenuItem(
                value: ProfileMenuAction.setPhoto,
                child: MenuItem(
                  icon: Icons.photo_camera_outlined,
                  text: 'Set profile photo',
                ),
              ),
              PopupMenuItem(
                value: ProfileMenuAction.changeUsername,
                child: MenuItem(
                  icon: Icons.alternate_email,
                  text: 'Change username',
                ),
              ),
            ],
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// PROFILE HEADER (tappable → Profile page)
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => context.pushNamed(RouteNames.profile),
                child: ProfileHeader(profile: profile!),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// INFO SECTION DIVIDER
            const SliverToBoxAdapter(child: Divider(thickness: 8)),

            /// PROFILE INFO (shared with Profile page)
            SliverToBoxAdapter(child: ProfileInfoSection(profile: profile)),

            /// SETTINGS DIVIDER
            const SliverToBoxAdapter(child: Divider(thickness: 8)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// SETTINGS LIST
            SliverList(
              delegate: SliverChildListDelegate([
                SettingsTile(
                  icon: Icons.notifications_none,
                  title: 'Notifications and Sounds',
                ),
                SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Privacy and Security',
                ),
                SettingsTile(icon: Icons.data_usage, title: 'Data and Storage'),
                SettingsTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat Settings',
                ),
                SettingsTile(icon: Icons.devices, title: 'Devices'),
                SettingsTile(icon: Icons.language, title: 'Language'),
              ]),
            ),

            if (logoutState.isLoading)
              const SliverToBoxAdapter(child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
