import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 10,
      color: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}
