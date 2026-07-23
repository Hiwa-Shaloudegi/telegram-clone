import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel profile;
  final String? subtitle;
  final Color? subtitleColor;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveSubtitle = subtitle ?? 'Online';
    final effectiveSubtitleColor = subtitleColor ?? theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: theme.primaryColor,
            backgroundImage: profile.hasProfileImage
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.hasProfileImage
                ? null
                : Text(
                    profile.shortDisplayName,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.displayName,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            effectiveSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: effectiveSubtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
