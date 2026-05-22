import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.height, this.child});

  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: child == null ? height ?? 10 : null,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}
