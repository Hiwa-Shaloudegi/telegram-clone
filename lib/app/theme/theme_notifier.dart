import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/local/theme/theme_local_service.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final theme = ref.read(themeLocalServiceProvider).getTheme();
    if (theme == 'dark') {
       return ThemeMode.dark;
    } else if (theme == 'light'){
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    ref.read(themeLocalServiceProvider).saveTheme(state.name);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    ref.read(themeLocalServiceProvider).saveTheme(mode.name);
  }
}
