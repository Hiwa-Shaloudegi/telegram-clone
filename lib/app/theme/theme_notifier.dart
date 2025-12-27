import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/local_storage_constants.dart';
import 'package:telegram_clone/data/local/storage/local_storage_service.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final theme = ref.read(localStorageServiceProvider).getTheme();
    if (theme == LocalStorageConstants.dark) {
      return ThemeMode.dark;
    } else if (theme == LocalStorageConstants.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    ref.read(localStorageServiceProvider).saveTheme(state.name);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    ref.read(localStorageServiceProvider).saveTheme(mode.name);
  }
}
