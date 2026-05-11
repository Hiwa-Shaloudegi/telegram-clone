import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/theme/theme_notifier.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

// TODO: Refactor
class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: borderRadius,
      ),
    );
  }
}

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserProfileAsync = ref.watch(userProfileQueryProvider);

    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: theme.primaryColor),
      accountName: currentUserProfileAsync.when(
        data: (profile) => Text(
          profile.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        loading: () => const Skeleton(width: 120, height: 14),
        error: (_, _) => const Text('User'),
      ),
      accountEmail: currentUserProfileAsync.when(
        data: (profile) => Text(
          profile.phone ?? profile.email ?? '',
          style: TextStyle(color: Colors.white.withAlpha(204)),
        ),
        loading: () => const Skeleton(width: 120, height: 14),
        error: (_, _) => const SizedBox.shrink(),
      ),
      currentAccountPicture: currentUserProfileAsync.when(
        data: (profile) => Padding(
          padding: const EdgeInsets.all(1),
          child: CircleAvatar(
            backgroundColor: Colors.white70,
            backgroundImage:
                profile.hasProfileImage && profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.hasProfileImage && profile.profileImageUrl != null
                ? null
                : Center(
                    child: Text(
                      profile.initials,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
          ),
        ),
        loading: () =>
            const CircleAvatar(backgroundColor: Colors.white24, radius: 28),
        error: (_, _) => const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.error, color: Colors.red),
        ),
      ),
      onDetailsPressed: () {
        // Expand account list/switch account functionality
        // This is the "arrow" behavior in Telegram
      },
      otherAccountsPictures: [
        // Placeholder for the "Sun/Moon" theme toggle acting as a secondary action or account
        GestureDetector(
          onTap: () {
            // Theme toggle logic handled in parent/main usually, but could be here
            // For now just an icon to mimic look
          },
          child: Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeProvider);

              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
