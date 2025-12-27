import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/features/auth/notifiers/command/complete_profile_command.dart';
import 'package:telegram_clone/features/auth/notifiers/ui/profile_info_ui_state.dart';

class ProfileInfoPage extends ConsumerStatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  ConsumerState<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends ConsumerState<ProfileInfoPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  // final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onComplete() async {
    if (_formKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final displayName = '$firstName $lastName'.trim();

      await ref
          .read(completeProfileCommandProvider.notifier)
          .run(
            displayName: displayName,
            profileImage: ref.read(profileInfoUi_selectedProfileImageProvider),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<AsyncValue<void>>(completeProfileCommandProvider, (_, next) {
      next.when(
        data: (_) {
          context.go(RouteNames.chats);
        },
        error: (error, stackTrace) {
          AppSnackbar.showError(context, error.toString());
        },
        loading: () {},
      );
    });

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedImage = ref.watch(
                        profileInfoUi_selectedProfileImageProvider,
                      );
                      return GestureDetector(
                        onTap: () async {
                          await ref
                              .read(
                                profileInfoUi_selectedProfileImageProvider
                                    .notifier,
                              )
                              .pickImage();
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: selectedImage != null
                              ? (kIsWeb
                                    ? NetworkImage(selectedImage.path)
                                    : FileImage(File(selectedImage.path))
                                          as ImageProvider)
                              : null,
                          child: selectedImage == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: theme.primaryColor,
                                )
                              : null,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Profile Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Enter your name and add a profile picture.'),
                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputTextField(
                          controller: _lastNameController,
                          label: 'Last Name (Optional)',
                        ),

                        // Consumer(
                        //   builder: (context, ref, _) {
                        //     final isUsernameAvailableAsync = ref.watch(
                        //       checkUsernameAvailabilityCommandProvider,
                        //     );
                        //     return InputTextField(
                        //       controller: _usernameController,
                        //       label: 'Username',
                        //       onChanged: (value) {
                        //         // TODO:
                        //         if (value.length >= 3) {
                        //           ref
                        //               .read(
                        //                 checkUsernameAvailabilityCommandProvider
                        //                     .notifier,
                        //               )
                        //               .run(username: value);
                        //         }
                        //       },
                        //       validator: (value) {
                        //         if (value == null || value.trim().isEmpty) {
                        //           return 'Please enter a username';
                        //         }
                        //         if (value.length < 3) {
                        //           return 'Username must be at least 3 characters';
                        //         }
                        //         if (value.length > 30) {
                        //           return 'Username must be less than 30 characters';
                        //         }
                        //         if (!RegExp(
                        //           r'^[a-zA-Z0-9_]+$',
                        //         ).hasMatch(value)) {
                        //           return 'Username can only contain letters, numbers, and underscores';
                        //         }
                        //         return null;
                        //       },
                        //       suffixIcon: Consumer(
                        //         builder: (context, ref, child) {
                        //           return isUsernameAvailableAsync.when(
                        //             data: (isUsernameAvailable) {
                        //               if (isUsernameAvailable != null &&
                        //                   isUsernameAvailable) {
                        //                 return Icon(
                        //                   Icons.check_circle,
                        //                   color: Colors.green,
                        //                 );
                        //               } else if (isUsernameAvailable == null) {
                        //                 return SizedBox.shrink();
                        //               } else {
                        //                 return Icon(
                        //                   Icons.cancel,
                        //                   color: Colors.red,
                        //                 );
                        //               }
                        //             },
                        //             loading: () => const Padding(
                        //               padding: EdgeInsets.all(12.0),
                        //               child: SizedBox(
                        //                 width: 20,
                        //                 height: 20,
                        //                 child: CircularProgressIndicator(
                        //                   strokeWidth: 2,
                        //                 ),
                        //               ),
                        //             ),
                        //             error: (_, _) => SizedBox.shrink(),
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),

                        // SizedBox(height: 4),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: Consumer(
                        //     builder: (context, ref, _) {
                        //       final isUsernameAvailableAsync = ref.watch(
                        //         checkUsernameAvailabilityCommandProvider,
                        //       );

                        //       return isUsernameAvailableAsync.when(
                        //         data: (isUsernameAvailable) {
                        //           if (isUsernameAvailable == false) {
                        //             return Text(
                        //               '@${_usernameController.text} is not available',
                        //               style: const TextStyle(color: Colors.red),
                        //             );
                        //           }
                        //           return const SizedBox.shrink();
                        //         },
                        //         error: (_, _) => Text(
                        //           '@${_usernameController.text} is not available',
                        //           style: const TextStyle(color: Colors.red),
                        //         ),
                        //         loading: () => const SizedBox.shrink(),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  PrimaryButton(
                    text: 'Start Messaging',
                    isLoading: ref
                        .watch(completeProfileCommandProvider)
                        .isLoading,
                    onPressed: _onComplete,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
