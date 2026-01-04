import 'package:flutter/material.dart';
import 'package:telegram_clone/data/models/user_profile.dart';
import 'package:telegram_clone/features/settings/ui/widgets/profile_header.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeaderSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ProfileHeader(profile: profile),
    );
  }
}
