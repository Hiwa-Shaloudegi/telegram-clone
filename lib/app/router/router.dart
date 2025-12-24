import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/pages/not_found_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/login_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/profile_info_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/signup_page.dart';
import 'package:telegram_clone/features/chats/ui/pages/chats_screen.dart';
import 'package:telegram_clone/features/splash/ui/pages/splash_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const NotFoundScreen(),
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
