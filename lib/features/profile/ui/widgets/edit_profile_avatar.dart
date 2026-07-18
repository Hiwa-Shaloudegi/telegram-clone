import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';

/// Large circular avatar with Telegram-style camera badge.
class EditProfileAvatar extends StatelessWidget {
  final UserProfileModel? profile;
  final XFile? localImage;
  final bool photoRemoved;
  final VoidCallback? onTap;

  const EditProfileAvatar({
    super.key,
    this.profile,
    this.localImage,
    this.photoRemoved = false,
    this.onTap,
  });

  bool get _hasVisiblePhoto {
    if (localImage != null) return true;
    if (photoRemoved) return false;
    return profile?.hasProfileImage == true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: theme.primaryColor,
                  backgroundImage: _imageProvider(),
                  child: _imageProvider() == null
                      ? Text(
                          profile?.shortDisplayName ?? 'U',
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _hasVisiblePhoto ? 'Change Photo' : 'Set Photo',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _imageProvider() {
    if (localImage != null) {
      if (kIsWeb) {
        return NetworkImage(localImage!.path);
      }
      return FileImage(File(localImage!.path));
    }
    if (!photoRemoved && profile?.hasProfileImage == true) {
      return NetworkImage(profile!.profileImageUrl!);
    }
    return null;
  }
}
