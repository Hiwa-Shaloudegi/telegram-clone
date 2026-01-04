import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/data/models/user_profile.dart';
import 'package:telegram_clone/features/auth/notifiers/command/logout_command.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserProfileAsync = ref.watch(userProfileQueryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return AppScaffold(
      appBar: AppBar(
        title: currentUserProfileAsync.when(
          data: (profile) => Text(profile.displayName),
          loading: () => const Text('Profile'),
          error: (_, _) => const Text('Profile'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(RouteNames.editProfile),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'share':
                  AppSnackbar.showSuccess(context, 'Share profile coming soon');
                  break;
                case 'logout':
                  ref.read(logoutCommandProvider.notifier).run();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: currentUserProfileAsync.when(
        data: (profile) =>
            _buildProfileContent(context, theme, profile, currentUser?.email),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading profile: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {}, // ref.invalidate(userProfileQueryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    ThemeData theme,
    UserProfile profile,
    String? authEmail,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Profile Picture
          CircleAvatar(
            radius: 60,
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            backgroundImage:
                profile.hasProfileImage && profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.hasProfileImage && profile.profileImageUrl != null
                ? null
                : Text(
                    profile.initials,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          // Info Sections
          _buildInfoSection(context, theme, profile, authEmail),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    ThemeData theme,
    UserProfile profile,
    String? authEmail,
  ) {
    final List<Widget> infoTiles = [];

    // Phone
    if (profile.phone != null && profile.phone!.isNotEmpty) {
      infoTiles.add(
        _buildInfoTile(
          context,
          theme,
          icon: Icons.phone,
          label: 'Phone',
          value: profile.phone!,
        ),
      );
    }

    // Username
    if (profile.username != null && profile.username!.isNotEmpty) {
      infoTiles.add(
        _buildInfoTile(
          context,
          theme,
          icon: Icons.alternate_email,
          label: 'Username',
          value: profile.usernameWithoutAt ?? profile.username!,
        ),
      );
    }

    // Bio
    if (profile.bio != null && profile.bio!.isNotEmpty) {
      infoTiles.add(
        _buildInfoTile(
          context,
          theme,
          icon: Icons.info_outline,
          label: 'Bio',
          value: profile.bio!,
          isMultiline: true,
        ),
      );
    }

    // Email
    final email = authEmail ?? profile.email;
    if (email != null && email.isNotEmpty) {
      infoTiles.add(
        _buildInfoTile(
          context,
          theme,
          icon: Icons.email,
          label: 'Email',
          value: email,
        ),
      );
    }

    if (infoTiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No additional information available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: infoTiles.asMap().entries.map((entry) {
          final index = entry.key;
          final tile = entry.value;
          final isLast = index == infoTiles.length - 1;
          return Column(
            children: [
              tile,
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 56,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
