import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/features/splash/notifiers/splash_destination_notifier.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.listen(splashDestinationProvider, (previous, next) {
      next.whenData((route) {
        if (context.mounted) {
          context.goNamed(route);
        }
      });
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Icon(Icons.telegram, size: 120, color: theme.primaryColor),
      ),
    );
  }
}
