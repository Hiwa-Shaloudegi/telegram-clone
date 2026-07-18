import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/profile_header_section.dart';
import 'package:telegram_clone/core/ui/widgets/profile_info_section.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/features/profile/notifiers/command/update_profile_command.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:telegram_clone/features/profile/ui/widgets/profile_photo_bottom_sheet.dart';
import 'package:telegram_clone/features/settings/ui/widgets/menu_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileQueryProvider);

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
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: ProfileMenuAction.editInfo,
                child: MenuItem(icon: Icons.edit_outlined, text: 'Edit info'),
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
      body: SafeArea(
        bottom: true,
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('Profile not found'));
            }
            return ListView(
              children: [
                const SizedBox(height: 10),
                ProfileHeaderSection(profile: profile),
                const SizedBox(height: 16),
                const SectionDivider(),
                ProfileInfoSection(profile: profile),
              ],
            );
          },
        ),
      ),
    );
  }
}
