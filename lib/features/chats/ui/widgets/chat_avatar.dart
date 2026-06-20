// lib/features/chats/ui/widgets/chat_avatar.dart

import 'package:flutter/material.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';

/// Displays a chat avatar. Falls back to coloured initials when no [imageUrl].
/// Shows a special icon for channels and saved messages.
class ChatAvatar extends StatelessWidget {
  final String displayTitle;
  final String? imageUrl;
  final ChatType chatType;
  final double size;

  const ChatAvatar({
    super.key,
    required this.displayTitle,
    this.imageUrl,
    required this.chatType,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    if (chatType == ChatType.saved) {
      return _iconAvatar(context, Icons.bookmark, Colors.blue);
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: _colorForTitle(displayTitle),
      );
    }

    if (chatType == ChatType.channel) {
      return _iconAvatar(context, Icons.campaign_outlined, Colors.blueGrey);
    }

    // Initials fallback
    final initials = _initials(displayTitle);
    final bg = _colorForTitle(displayTitle);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.38,
        ),
      ),
    );
  }

  Widget _iconAvatar(BuildContext context, IconData icon, Color color) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _colorForTitle(String title) {
    final colors = [
      const Color(0xFFE57373), // red
      const Color(0xFF81C784), // green
      const Color(0xFF64B5F6), // blue
      const Color(0xFFFFB74D), // orange
      const Color(0xFFBA68C8), // purple
      const Color(0xFF4DB6AC), // teal
      const Color(0xFFF06292), // pink
      const Color(0xFFA1887F), // brown
    ];
    final hash = title.codeUnits.fold(0, (a, b) => a + b);
    return colors[hash % colors.length];
  }
}
