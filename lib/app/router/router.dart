import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/core/ui/pages/not_found_page.dart';
import 'package:telegram_clone/features/auth/ui/pages/login_screen.dart';
import 'package:telegram_clone/features/auth/ui/pages/signup_screen.dart';
import 'package:telegram_clone/features/chats/ui/pages/chats_screen.dart';
import 'package:telegram_clone/features/splash/ui/screens/splash_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.signup,
    errorBuilder: (context, state) => const NotFoundScreen(),
    // redirect: (context, state) {
  
    //   final isLoading = true; //authState.isLoading;
    //   final isAuthenticated = true; //authState.valueOrNull ?? false;

    //   final String location = state.uri.toString();
    //   final isSplash = location == RouteNames.splash;
    //   final isLogin = location == RouteNames.login;
    //   final isSignup = location == RouteNames.signup;

    //   // 1. If initializing, show splash
    //   if (isLoading) {
    //      return RouteNames.splash;
    //   }

    //   // 2. If finished loading and still on splash, redirect
    //   if (isSplash) {
    //     return isAuthenticated ? RouteNames.chats : RouteNames.login;
    //   }

    //   // 3. Authenticated user trying to access auth pages -> send to home
    //   if (isAuthenticated) {
    //     if (isLogin || isSignup) {
    //       return RouteNames.chats;
    //     }
    //   } 
    //   // 4. Unauthenticated user trying to access protected pages -> send to login
    //   else {
    //     if (!isLogin && !isSignup) {
    //       return RouteNames.login;
    //     }
    //   }

    //   return null;
    // },
  
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // GoRoute(
      //   path: RouteNames.chats,
      //   builder: (context, state) => const ChatsScreen(),
      // ),
      // GoRoute(
      //   path: RouteNames.login,
      //   builder: (context, state) => const LoginScreen(),
      // ),
      // GoRoute(
      //   path: RouteNames.signup,
      //   builder: (context, state) => const SignupScreen(),
      // ),
    ],
  );
}
