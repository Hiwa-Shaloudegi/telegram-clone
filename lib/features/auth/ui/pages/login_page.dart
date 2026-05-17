import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/core/ui/widgets/secondary_button.dart';
import 'package:telegram_clone/features/auth/notifiers/command/login_command.dart';
import 'package:telegram_clone/features/auth/notifiers/command/login_with_google_command.dart';
import 'package:telegram_clone/features/auth/notifiers/ui/login_ui_state.dart';
import 'package:telegram_clone/features/auth/ui/widgets/auth_header.dart';
import 'package:telegram_clone/features/auth/ui/widgets/google_sign_in_button.dart';
import 'package:telegram_clone/features/auth/ui/widgets/or_divider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

    ref.listen<AsyncValue<void>>(loginWithGoogleCommandProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, error.toString()),
      );
    });

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
                      obscureText: ref.watch(loginUi_isPasswordObscureProvider),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: ref.watch(loginUi_isPasswordObscureProvider)
                            ? const Icon(Icons.visibility_off_rounded)
                            : const Icon(Icons.visibility_rounded),
                        onPressed: () {
                          ref
                              .read(loginUi_isPasswordObscureProvider.notifier)
                              .set(
                                !ref.read(loginUi_isPasswordObscureProvider),
                              );
                        },
                      ),
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
                      isLoading: ref.watch(loginCommandProvider).isLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ref
                              .read(loginCommandProvider.notifier)
                              .run(
                                _emailController.text,
                                _passwordController.text,
                              );
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                    const OrDivider(),
                    const SizedBox(height: 16),
                    GoogleSignInButton(
                      isLoading: ref
                          .watch(loginWithGoogleCommandProvider)
                          .isLoading,
                      onPressed: () {
                        ref.read(loginWithGoogleCommandProvider.notifier).run();
                      },
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        SecondaryButton(
                          text: 'Sign Up',
                          onPressed: () => context.goNamed(RouteNames.signup),
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
