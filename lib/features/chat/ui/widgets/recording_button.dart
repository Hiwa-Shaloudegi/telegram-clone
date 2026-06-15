import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final VoidCallback onStop;
  const RecordingButton({super.key, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'stop_fab',
      onPressed: onStop,
      elevation: 0,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(Icons.stop_rounded),
    );
  }
}
