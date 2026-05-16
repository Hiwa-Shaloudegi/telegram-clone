import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/pages/not_found_page.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';
import 'package:telegram_clone/features/auth/ui/pages/login_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/profile_info_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/signup_page.dart';
import 'package:telegram_clone/features/chats/ui/pages/chats_page.dart';
import 'package:telegram_clone/features/contacts/ui/pages/contacts_page.dart';
import 'package:telegram_clone/features/profile/ui/pages/edit_profile_page.dart';
import 'package:telegram_clone/features/profile/ui/pages/profile_page.dart';
import 'package:telegram_clone/features/settings/ui/pages/settings_page.dart';
import 'package:telegram_clone/features/splash/ui/pages/splash_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final userValueNotifier = ValueNotifier<User?>(ref.read(currentUserProvider));

  ref.listen<User?>(currentUserProvider, (prev, next) {
    userValueNotifier.value = next;
  });

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: userValueNotifier,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.chats,
        builder: (context, state) => const ChatsPage(),
      ),
      GoRoute(
        path: RouteNames.profileInfo,
        builder: (context, state) => const ProfileInfoPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.contacts,
        builder: (context, state) => const ContactsPage(),
      ),
    ],
    redirect: (context, state) {
      final isAuthRoute =
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.signup;
      final isSplashRoute = state.matchedLocation == RouteNames.splash;

      // Don't redirect while on splash, it has its own logic
      if (isSplashRoute) return null;

      if (ref.read(currentUserProvider) == null) {
        // Not logged in: allow only auth routes
        if (!isAuthRoute) return RouteNames.login;
      } else {
        // Logged in: redirect away from auth routes to chats
        if (isAuthRoute) return RouteNames.chats;
      }

      return null;
    },
  );
}
