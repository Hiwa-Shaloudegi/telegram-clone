import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onTap;
  const SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      key: const ValueKey('send'),
      heroTag: 'send_fab',
      onPressed: onTap,
      foregroundColor: Colors.white,
      elevation: 0,
      child: const Icon(Icons.send_rounded, size: 18),
    );
  }
}
