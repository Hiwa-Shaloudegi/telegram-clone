import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          Icons.telegram,
          size: iconSize,
          color: theme.primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
