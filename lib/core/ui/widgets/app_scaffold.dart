import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  final bool dismissKeyboardOnTap;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.dismissKeyboardOnTap = true,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = body;

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    if (dismissKeyboardOnTap) {
      content = GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      appBar: appBar,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
