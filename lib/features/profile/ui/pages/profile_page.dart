import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/profile_header_section.dart';
import 'package:telegram_clone/core/ui/widgets/profile_info_section.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:telegram_clone/features/settings/ui/widgets/menu_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileQueryProvider);

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
          data: (profile) => ListView(
            children: [
              const SizedBox(height: 10),
              ProfileHeaderSection(profile: profile!),

              const SizedBox(height: 16),
              SectionDivider(),

              ProfileInfoSection(profile: profile),
            ],
          ),
        ),
      ),
    );
  }
}
