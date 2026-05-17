import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/widgets/app_scaffold.dart';
import 'package:telegram_clone/core/ui/widgets/app_snackbar.dart';
import 'package:telegram_clone/core/ui/widgets/input_text_field.dart';
import 'package:telegram_clone/core/ui/widgets/primary_button.dart';
import 'package:telegram_clone/core/ui/widgets/secondary_button.dart';
import 'package:telegram_clone/features/auth/notifiers/command/signup_command.dart';
import 'package:telegram_clone/features/auth/notifiers/ui/signup_ui_state.dart';
import 'package:telegram_clone/features/auth/ui/widgets/auth_header.dart';
import 'package:telegram_clone/features/auth/ui/widgets/google_sign_in_button.dart';
import 'package:telegram_clone/features/auth/ui/widgets/or_divider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
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

  void _onSignup() async {
    if (_passwordController.text != _repeatPasswordController.text) {
      AppSnackbar.showError(context, 'Passwords do not match');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(signupCommandProvider.notifier)
          .run(_emailController.text.trim(), _passwordController.text);
    }
  }

  void _onGoogleSignup() async {
    // TODO: Complete Google signup logic
    //if already has an account, link instead of create new, then navigate to chats page
    // if not, create new account and navigate to profile info page
    //await ref.read(loginWithGoogleCommandProvider.notifier).run();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(signupCommandProvider, (_, next) {
      next.when(
        data: (_) {
          context.goNamed(RouteNames.profileInfo);
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const AuthHeader(
                      title: 'Join Telegram',
                      subtitle: 'Create an account to start chatting',
                      iconSize: 100,
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
                      obscureText: ref.watch(
                        signupUi_isPasswordObscureProvider,
                      ),
                      suffixIcon: IconButton(
                        icon: ref.watch(signupUi_isPasswordObscureProvider)
                            ? Icon(Icons.visibility_off_rounded)
                            : Icon(Icons.visibility_rounded),
                        onPressed: () {
                          ref
                              .read(signupUi_isPasswordObscureProvider.notifier)
                              .set(
                                !ref.read(signupUi_isPasswordObscureProvider),
                              );
                        },
                      ),

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
                      obscureText: ref.watch(
                        signupUi_isRepeatPasswordObscureProvider,
                      ),
                      suffixIcon: IconButton(
                        icon:
                            ref.watch(signupUi_isRepeatPasswordObscureProvider)
                            ? Icon(Icons.visibility_off_rounded)
                            : Icon(Icons.visibility_rounded),
                        onPressed: () {
                          ref
                              .read(
                                signupUi_isRepeatPasswordObscureProvider
                                    .notifier,
                              )
                              .set(
                                !ref.read(
                                  signupUi_isRepeatPasswordObscureProvider,
                                ),
                              );
                        },
                      ),

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
                      isLoading: ref.watch(signupCommandProvider).isLoading,
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
                          onPressed: () => context.goNamed(RouteNames.login),
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
