import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/app/router/extra/user_profile_extra.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/profile_header_section.dart';
import 'package:telegram_clone/core/ui/widgets/profile_info_section.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/data/models/user_presence_model.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_by_id_query.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_presence_query.dart';

/// Telegram-style read-only profile page shown when you tap a user's avatar
/// or name from a chat. Mirrors the layout of the real Telegram app:
/// - Big avatar + display name + last-seen subtitle
/// - Info section (username / phone / bio)
/// - Notifications toggle row
/// - Send message / media actions
class UserProfilePage extends ConsumerWidget {
  final UserProfileExtra? extra;

  const UserProfilePage({super.key, this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = GoRouterState.of(context).pathParameters['userId']!;

    final profileAsync = ref.watch(userByIdQueryProvider(userId));
    final presenceAsync = ref.watch(userPresenceQueryProvider(userId));

    final subtitle = presenceAsync.when(
      data: (presence) => presence?.getDisplayStatus(null),
      loading: () => null,
      error: (_, _) => null,
    );

    return AppScaffold(
      appBar: AppBar(
        title: extra?.displayName != null
            ? Text(extra!.displayName!)
            : const Text('Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showActions(context, ref),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () => ref.invalidate(userByIdQueryProvider(userId)),
        ),
        data: (profile) {
          return ListView(
            children: [
              const SizedBox(height: 10),
              ProfileHeaderSection(
                profile: profile,
                subtitle: subtitle,
                subtitleColor: _subtitleColor(context, presenceAsync),
              ),
              const SizedBox(height: 16),
              const SectionDivider(),
              ProfileInfoSection(profile: profile),
              const SectionDivider(),
              _SettingsRows(
                userId: userId,
                displayName: profile.displayName,
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Color? _subtitleColor(BuildContext context, AsyncValue<UserPresenceModel?> presenceAsync) {
    final presence = presenceAsync.asData?.value;
    if (presence != null && presence.isActuallyOnline) {
      return Theme.of(context).primaryColor;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block user',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRows extends ConsumerWidget {
  final String userId;
  final String displayName;

  const _SettingsRows({required this.userId, required this.displayName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: Icon(
              extraIconFor(userId),
              color: theme.colorScheme.primary,
            ),
            title: const Text('Media'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  IconData extraIconFor(String userId) {
    final colors = [
      Icons.image_outlined,
      Icons.perm_media_outlined,
      Icons.photo_library_outlined,
    ];
    return colors[userId.hashCode % colors.length];
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $message', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
