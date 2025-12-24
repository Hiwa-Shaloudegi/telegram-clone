import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_clone/core/constants/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // TODO: Integrate actual auth check here using Riverpod provider
    bool isAuthenticated = false;

    // ignore: dead_code
    if (isAuthenticated) {
      context.go(RouteNames.chats);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Icon(
          Icons.telegram,
          size: 120,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
