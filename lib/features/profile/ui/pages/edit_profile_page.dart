import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';
import 'package:telegram_clone/features/profile/notifiers/command/update_profile_command.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';
import 'package:telegram_clone/features/profile/notifiers/ui/edit_profile_ui_state.dart';
import 'package:telegram_clone/features/profile/ui/widgets/edit_profile_avatar.dart';
import 'package:telegram_clone/features/profile/ui/widgets/edit_profile_nav_row.dart';
import 'package:telegram_clone/features/profile/ui/widgets/edit_profile_text_field.dart';
import 'package:telegram_clone/features/profile/ui/widgets/profile_photo_bottom_sheet.dart';

/// Telegram-style Edit Profile screen.
///
/// Layout mirrors Telegram Android/iOS:
/// - App bar with back + check (done)
/// - Avatar with camera badge + "Set/Change Photo"
/// - Underlined First Name / Last Name / Bio fields
/// - Username row → dedicated username page
/// - Unsaved-changes dialog on back
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();

  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalBio = '';

  bool get _hasChanges {
    return _firstNameController.text.trim() != _originalFirstName ||
        _lastNameController.text.trim() != _originalLastName ||
        _bioController.text.trim() != _originalBio ||
        ref.read(editProfile_localImageProvider) != null ||
        ref.read(editProfile_photoRemovedProvider);
  }

  void _initializeFromProfile(UserProfileModel profile) {
    _originalFirstName = profile.firstName;
    _originalLastName = profile.lastName ?? '';
    _originalBio = profile.bio ?? '';

    ref.read(editProfile_currentUsernameProvider.notifier).set(profile.usernameWithoutAt);

    _firstNameController
      ..text = _originalFirstName
      ..addListener(_onFieldChanged);
    _lastNameController
      ..text = _originalLastName
      ..addListener(_onFieldChanged);
    _bioController
      ..text = _originalBio
      ..addListener(_onFieldChanged);

    ref.read(editProfile_initializedProvider.notifier).set(true);
  }

  void _onFieldChanged() {
    ref.read(editProfile_changeTickProvider.notifier).tick();
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _bioController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      ref.read(editProfile_localImageProvider.notifier).set(picked);
      ref.read(editProfile_photoRemovedProvider.notifier).set(false);
    }
  }

  void _removePhoto() {
    ref.read(editProfile_localImageProvider.notifier).set(null);
    ref.read(editProfile_photoRemovedProvider.notifier).set(true);
  }

  void _showPhotoSheet(UserProfileModel? profile) {
    final localImage = ref.read(editProfile_localImageProvider);
    final photoRemoved = ref.read(editProfile_photoRemovedProvider);
    final hasPhoto =
        localImage != null ||
        (!photoRemoved && profile?.hasProfileImage == true);

    ProfilePhotoBottomSheet.show(
      context: context,
      hasPhoto: hasPhoto,
      onPickImage: _pickImage,
      onRemovePhoto: hasPhoto ? _removePhoto : null,
    );
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_hasChanges) {
      context.pop();
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final bio = _bioController.text.trim();
    final localImage = ref.read(editProfile_localImageProvider);
    final photoRemoved = ref.read(editProfile_photoRemovedProvider);

    try {
      await ref.read(updateProfileCommandProvider.notifier).run(
            firstName: firstName != _originalFirstName ? firstName : null,
            lastName: lastName != _originalLastName ? lastName : null,
            bio: bio != _originalBio ? bio : null,
            localImage: localImage,
            removePhoto: photoRemoved && localImage == null,
          );

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Profile updated');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, e.toString());
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Do you want to apply them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'discard'),
              child: Text(
                'Discard',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'apply'),
              child: Text(
                'Apply',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == 'apply') {
      await _onSave();
      return false; // save handles pop
    }
    if (result == 'discard') return true;
    return false;
  }

  Future<void> _onBack() async {
    final canLeave = await _confirmDiscard();
    if (canLeave && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileQueryProvider);
    final updateState = ref.watch(updateProfileCommandProvider);
    final isSaving = updateState.isLoading;
    final localImage = ref.watch(editProfile_localImageProvider);
    final photoRemoved = ref.watch(editProfile_photoRemovedProvider);
    final initialized = ref.watch(editProfile_initializedProvider);
    final currentUsername = ref.watch(editProfile_currentUsernameProvider);
    // Watch change tick to rebuild when text controllers change
    ref.watch(editProfile_changeTickProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Keep username label in sync when returning from Change Username page
    ref.listen(userProfileQueryProvider, (prev, next) {
      next.whenData((profile) {
        if (profile != null && mounted) {
          ref.read(editProfile_currentUsernameProvider.notifier).set(
            profile.usernameWithoutAt,
          );
        }
      });
    });

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onBack();
      },
      child: AppScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: isSaving ? null : _onBack,
          ),
          title: const Text('Edit Profile'),
          actions: [
            if (isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: _hasChanges ? Colors.white : Colors.white54,
                ),
                tooltip: 'Done',
                onPressed: _hasChanges ? _onSave : null,
              ),
          ],
        ),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorBody(
            message: error.toString(),
            onRetry: () => ref.invalidate(userProfileQueryProvider),
          ),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('Profile not found'));
            }

            if (!initialized) {
              // Schedule after this frame to avoid mutating controllers mid-build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !ref.read(editProfile_initializedProvider)) {
                  _initializeFromProfile(profile);
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 28),

                  // Avatar
                  EditProfileAvatar(
                    profile: profile,
                    localImage: localImage,
                    photoRemoved: photoRemoved,
                    onTap: isSaving ? null : () => _showPhotoSheet(profile),
                  ),

                  const SizedBox(height: 28),
                  const SectionDivider(height: 12),
                  const SizedBox(height: 8),

                  // First name
                  EditProfileTextField(
                    controller: _firstNameController,
                    label: 'First name',
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),

                  // Last name
                  EditProfileTextField(
                    controller: _lastNameController,
                    label: 'Last name',
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 4),

                  // Bio
                  EditProfileTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'Add a few words about yourself',
                    maxLines: 3,
                    maxLength: 70,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value != null && value.length > 70) {
                        return 'Bio must be 70 characters or less';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  const SectionDivider(height: 12),

                  // Username → dedicated page
                  EditProfileNavRow(
                    label: 'Username',
                    value: (currentUsername ?? '').isNotEmpty
                        ? '@$currentUsername'
                        : null,
                    emptyLabel: 'None',
                    onTap: isSaving
                        ? null
                        : () => context.pushNamed(RouteNames.changeUsername),
                  ),

                  Divider(
                    height: 1,
                    indent: 20,
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),

                  // Phone (read-only, like Telegram)
                  if ((profile.phone ?? '').isNotEmpty)
                    EditProfileNavRow(
                      label: 'Phone',
                      value: profile.phone,
                      showChevron: false,
                    ),

                  const SizedBox(height: 24),

                  // Helper text (Telegram-style)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Any details you enter here will be visible to people '
                      'you message, contacts, and groups.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading profile: $message', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
