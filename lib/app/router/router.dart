import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/pages/not_found_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/login_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/profile_info_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/signup_page.dart';
import 'package:telegram_clone/features/chats/ui/pages/chats_screen.dart';
import 'package:telegram_clone/features/splash/ui/pages/splash_page.dart';

import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) {
      final isAuthRoute =
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.signup;
      final isSplashRoute = state.matchedLocation == RouteNames.splash;

      // Don't redirect while on splash, it has its own logic
      if (isSplashRoute) return null;

      if (user == null) {
        // Not logged in: allow only auth routes
        if (!isAuthRoute) return RouteNames.login;
      } else {
        // Logged in: redirect away from auth routes to chats
        if (isAuthRoute) return RouteNames.chats;
      }

      return null;
    },
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
        builder: (context, state) => const ChatsScreen(),
      ),
      GoRoute(
        path: RouteNames.profileInfo,
        builder: (context, state) => const ProfileInfoPage(),
      ),
    ],
  );
}
