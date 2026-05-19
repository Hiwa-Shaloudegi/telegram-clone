import 'package:flutter/material.dart';

enum ProfileMenuAction { editInfo, setPhoto, changeUsername }

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const MenuItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
        const SizedBox(width: 12),
        Text(text),
      ],
    );
  }
}
