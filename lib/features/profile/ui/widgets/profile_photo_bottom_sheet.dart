import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Telegram-style bottom sheet for profile photo actions.
class ProfilePhotoBottomSheet extends StatelessWidget {
  final bool hasPhoto;
  final Function(ImageSource source) onPickImage;
  final VoidCallback? onRemovePhoto;

  const ProfilePhotoBottomSheet({
    super.key,
    required this.hasPhoto,
    required this.onPickImage,
    this.onRemovePhoto,
  });

  static Future<void> show({
    required BuildContext context,
    required bool hasPhoto,
    required Function(ImageSource source) onPickImage,
    VoidCallback? onRemovePhoto,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (context) => ProfilePhotoBottomSheet(
        hasPhoto: hasPhoto,
        onPickImage: onPickImage,
        onRemovePhoto: onRemovePhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            _PhotoActionTile(
              icon: Icons.camera_alt_outlined,
              label: 'Take a photo',
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.camera);
              },
            ),
            _PhotoActionTile(
              icon: Icons.image_outlined,
              label: 'Choose from gallery',
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.gallery);
              },
            ),
            if (hasPhoto && onRemovePhoto != null)
              _PhotoActionTile(
                icon: Icons.delete_outline,
                label: 'Delete photo',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  onRemovePhoto!();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PhotoActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _PhotoActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
