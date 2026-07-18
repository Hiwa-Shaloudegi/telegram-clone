import 'package:flutter/material.dart';

/// Telegram-style navigation row (e.g. Username, Birthday) on Edit Profile.
class EditProfileNavRow extends StatelessWidget {
  final String label;
  final String? value;
  final String emptyLabel;
  final VoidCallback? onTap;
  final bool showChevron;

  const EditProfileNavRow({
    super.key,
    required this.label,
    this.value,
    this.emptyLabel = 'None',
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasValue = value != null && value!.trim().isNotEmpty;
    final display = hasValue ? value! : emptyLabel;
    final valueColor = hasValue
        ? theme.colorScheme.onSurface
        : (isDark ? Colors.white38 : Colors.black38);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? const Color(0xFF6AB3F3)
                            : theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      display,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 17,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron && onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white38 : Colors.black26,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
