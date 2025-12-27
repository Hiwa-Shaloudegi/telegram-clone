import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/services/presence_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final presenceService = ref.read(presenceServiceProvider.notifier);
    
    if (state == AppLifecycleState.resumed) {
      presenceService.handleLifecycleChange(true);
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      presenceService.handleLifecycleChange(false);
    }
  }
}
