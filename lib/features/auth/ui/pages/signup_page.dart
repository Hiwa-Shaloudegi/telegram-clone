import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/core/ui/widgets/secondary_button.dart';
import 'package:telegram_clone/features/auth/ui/widgets/auth_header.dart';
import 'package:telegram_clone/features/auth/ui/widgets/google_sign_in_button.dart';
import 'package:telegram_clone/features/auth/ui/widgets/or_divider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _onSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _repeatPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      // TODO: Implement signup logic
      // Navigate to Profile Info upon success
      context.go(RouteNames.profileInfo);
    }
  }

  void _onGoogleSignup() {
    // TODO: Implement Google signup
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const AuthHeader(
                      title: 'Join Telegram',
                      subtitle: 'Create an account to start chatting',
                    ),
                    const SizedBox(height: 32),
                    InputTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _repeatPasswordController,
                      label: 'Repeat Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please repeat your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Sign Up',
                      onPressed: _onSignup,
                    ),
                    const SizedBox(height: 16),
                    const OrDivider(),
                    const SizedBox(height: 16),
                    GoogleSignInButton(
                      text: 'Sign up with Google',
                      onPressed: _onGoogleSignup,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        SecondaryButton(
                          text: 'Log In',
                          onPressed: () => context.go(RouteNames.login),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
