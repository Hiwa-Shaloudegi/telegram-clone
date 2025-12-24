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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
      // For now navigate to chats
      context.go(RouteNames.chats);
    }
  }

  void _onGoogleLogin() {
    // TODO: Implement Google login
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const AuthHeader(
                      title: 'Telegram',
                      subtitle: 'Please log in to continue',
                      iconSize: 100,
                    ),
                    const SizedBox(height: 48),
                    
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    PrimaryButton(
                      text: 'Log In',
                      onPressed: _onLogin,
                    ),
                    
                    const SizedBox(height: 16),
                    const OrDivider(),
                    const SizedBox(height: 16),
                    GoogleSignInButton(
                      onPressed: _onGoogleLogin,
                    ),

                    const Spacer(),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        SecondaryButton(
                          text: 'Sign Up',
                          onPressed: () => context.go(RouteNames.signup),
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
