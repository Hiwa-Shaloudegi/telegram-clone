import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onComplete() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save profile info
      context.go(RouteNames.chats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                  GestureDetector(
                    onTap: () {
                      // TODO: Pick image
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.add_a_photo, 
                        size: 40, 
                        color: theme.primaryColor
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Profile Info', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
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
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  PrimaryButton(
                    text: 'Start Messaging',
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
