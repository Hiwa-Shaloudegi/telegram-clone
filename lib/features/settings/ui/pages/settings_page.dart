import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/profile_info_section.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/profile/notifiers/command/update_profile_command.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:telegram_clone/features/profile/ui/widgets/profile_photo_bottom_sheet.dart';
import 'package:telegram_clone/features/settings/ui/widgets/menu_item.dart';
import 'package:telegram_clone/features/settings/ui/widgets/profile_header.dart';
import 'package:telegram_clone/features/settings/ui/widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _handleSetPhoto(BuildContext context, WidgetRef ref) async {
    final profile = await ref.read(userProfileQueryProvider.future);

    if (!context.mounted) return;

    ProfilePhotoBottomSheet.show(
      context: context,
      hasPhoto: profile?.hasProfileImage == true,
      onPickImage: (source) async {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        if (picked == null || !context.mounted) return;

        try {
          await ref
              .read(updateProfileCommandProvider.notifier)
              .run(localImage: picked);
          if (context.mounted) {
            AppSnackbar.showSuccess(context, 'Profile photo updated');
          }
        } catch (e) {
          if (context.mounted) {
            AppSnackbar.showError(context, e.toString());
          }
        }
      },
      onRemovePhoto: profile?.hasProfileImage == true
          ? () async {
              try {
                await ref
                    .read(updateProfileCommandProvider.notifier)
                    .run(removePhoto: true);
                if (context.mounted) {
                  AppSnackbar.showSuccess(context, 'Profile photo removed');
                }
              } catch (e) {
                if (context.mounted) {
                  AppSnackbar.showError(context, e.toString());
                }
              }
            }
          : null,
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Log out',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref.read(logoutCommandProvider.notifier).run();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileQueryProvider);
    final logoutState = ref.watch(logoutCommandProvider);

    ref.listen<AsyncValue<void>>(logoutCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    return AppScaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.editProfile),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit profile',
          ),
          PopupMenuButton<ProfileMenuAction>(
            onSelected: (action) {
              switch (action) {
                case ProfileMenuAction.editInfo:
                  context.pushNamed(RouteNames.editProfile);
                case ProfileMenuAction.setPhoto:
                  _handleSetPhoto(context, ref);
                case ProfileMenuAction.changeUsername:
                  context.pushNamed(RouteNames.changeUsername);
                case ProfileMenuAction.logout:
                  _confirmLogout(context, ref);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: ProfileMenuAction.editInfo,
                child: MenuItem(icon: Icons.edit, text: 'Edit info'),
              ),
              const PopupMenuItem(
                value: ProfileMenuAction.setPhoto,
                child: MenuItem(
                  icon: Icons.photo_camera_outlined,
                  text: 'Set profile photo',
                ),
              ),
              const PopupMenuItem(
                value: ProfileMenuAction.changeUsername,
                child: MenuItem(
                  icon: Icons.alternate_email,
                  text: 'Change username',
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: ProfileMenuAction.logout,
                child: MenuItem(
                  icon: Icons.logout,
                  text: 'Log out',
                  color: Theme.of(context).colorScheme.error,
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
            if (profile != null)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.profile),
                  child: ProfileHeader(profile: profile),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// INFO SECTION DIVIDER
            const SliverToBoxAdapter(child: Divider(thickness: 8)),

            /// PROFILE INFO (shared with Profile page)
            if (profile != null)
              SliverToBoxAdapter(child: ProfileInfoSection(profile: profile)),

            /// SETTINGS DIVIDER
            const SliverToBoxAdapter(child: Divider(thickness: 8)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Settings',
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
                SettingsTile(
                  icon: Icons.folder_outlined,
                  title: 'Folders',
                  onTap: () => context.pushNamed(RouteNames.folders),
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
