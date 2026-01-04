import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserProfileAsync = ref.watch(userProfileQueryProvider);

    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      padding: const EdgeInsets.only(top: 48, bottom: 16, left: 16, right: 16),
      child: currentUserProfileAsync.when(
        data: (profile) {
          final email = profile.email ?? profile.email ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                backgroundImage:
                    profile.hasProfileImage && profile.profileImageUrl != null
                    ? NetworkImage(profile.profileImageUrl!)
                    : null,
                child:
                    profile.hasProfileImage && profile.profileImageUrl != null
                    ? null
                    : Text(
                        profile.initials,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                profile.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Email
              if (email.isNotEmpty)
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
            ],
          );
        },
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 16,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white30,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
        error: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
