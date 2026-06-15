import 'package:flutter/material.dart';

class UnreadBadge extends StatelessWidget {
  final int count;
  final bool muted;
  const UnreadBadge({super.key, required this.count, required this.muted});

  @override
  Widget build(BuildContext context) {
    final color = muted
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primary;
    final textColor = muted
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onPrimary;

    final label = count > 999 ? '999+' : count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
