import 'package:flutter/material.dart';

class DrawerItemTile extends StatelessWidget {
  const DrawerItemTile({
    super.key,
    required this.title,
    required this.icon,
    this.foregroundColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color? foregroundColor;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: foregroundColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, color: foregroundColor),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
