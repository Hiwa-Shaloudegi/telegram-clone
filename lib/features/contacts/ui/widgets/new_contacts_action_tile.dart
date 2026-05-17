import 'package:flutter/material.dart';

class NewContactsActionTile extends StatelessWidget {
  const NewContactsActionTile({
    super.key,
    required this.title,
    this.leading,
    this.icon,
    this.onTap,
  });

  final String title;
  final Widget? leading;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(icon, size: 22),
      title: Text(title, style: TextStyle(fontSize: 15)),
      onTap: onTap,
    );
  }
}
