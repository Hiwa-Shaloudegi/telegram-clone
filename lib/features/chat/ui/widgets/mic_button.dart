import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  final VoidCallback onStart;
  const MicButton({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'mic_fab',
      onPressed: onStart,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      child: const Icon(Icons.mic_outlined),
    );
  }
}
