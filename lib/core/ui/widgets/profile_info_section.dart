import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';
import 'package:telegram_clone/features/settings/ui/widgets/info_tile.dart';

class ProfileInfoSection extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileInfoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    void addTile({required String title, required String subtitle}) {
      if (items.isNotEmpty) {
        items.add(const Divider(indent: 72, height: 1));
      }
      items.add(InfoTile(title: title, subtitle: subtitle));
    }

    if ((profile.email ?? '').isNotEmpty) {
      addTile(title: profile.email!, subtitle: 'Email');
    }

    if ((profile.phone ?? '').isNotEmpty) {
      addTile(title: profile.phone!, subtitle: 'Mobile');
    }

    if ((profile.username ?? '').isNotEmpty) {
      addTile(title: '@${profile.usernameWithoutAt}', subtitle: 'Username');
    }

    if ((profile.bio ?? '').isNotEmpty) {
      addTile(title: profile.bio!, subtitle: 'Bio');
    }

    if (profile.birthday != null) {
      addTile(
        title: DateFormat.yMMMMd().format(profile.birthday!),
        subtitle: 'Birthday',
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Info",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
