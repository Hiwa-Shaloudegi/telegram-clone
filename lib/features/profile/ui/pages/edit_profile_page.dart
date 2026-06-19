import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  final _formKey = GlobalKey<FormState>();
  // bool _isLoading = false;
  // bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // setState(() => _isLoading = true);

      try {
        final currentProfile = await ref.read(userProfileQueryProvider.future);
        final newUsername = _usernameController.text.trim();
        final currentUsername = currentProfile?.usernameWithoutAt ?? '';

        // Only update username if it has changed
        final usernameToUpdate =
            newUsername.isNotEmpty && newUsername != currentUsername
            ? newUsername
            : null;

        await ref
            .read(userApiProvider)
            .updateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              username: usernameToUpdate,
              bio: _bioController.text.trim(),
            );

        // Invalidate to refresh profile
        ref.invalidate(userProfileQueryProvider);

        if (mounted) {
          AppSnackbar.showSuccess(context, 'Profile updated successfully');
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          AppSnackbar.showError(context, e.toString());
        }
      } finally {
        // if (mounted) {
        // setState(() => _isLoading = false);
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileQueryProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        data: (profile) {
          // Initialize controllers with profile data only once
          // if (!_controllersInitialized) {
          //   _displayNameController.text = profile.displayName;
          //   _usernameController.text = profile.usernameWithoutAt ?? '';
          //   _bioController.text = profile.bio ?? '';
          //   _controllersInitialized = true;
          // }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  InputTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                  ),
                  const SizedBox(height: 16),
                  InputTextField(
                    controller: _usernameController,
                    label: 'Username (optional)',
                    prefixIcon: const Icon(Icons.alternate_email),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final username = value.trim();
                        if (username.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        if (username.length > 30) {
                          return 'Username must be less than 30 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
                          return 'Username can only contain letters, numbers, and underscores';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Bio (optional)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Save',
                    isLoading: false,
                    onPressed: _onSave,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading profile: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {}, // ref.invalidate(userProfileQueryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
