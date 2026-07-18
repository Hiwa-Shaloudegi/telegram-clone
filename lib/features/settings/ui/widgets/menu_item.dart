import 'package:flutter/material.dart';

enum ProfileMenuAction { editInfo, setPhoto, changeUsername, logout }

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).iconTheme.color;
    return Row(
      children: [
        Icon(icon, size: 20, color: resolvedColor),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
