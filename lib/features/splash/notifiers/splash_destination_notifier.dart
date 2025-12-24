import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/local/storage/local_storage_service.dart';
import 'package:telegram_clone/features/auth/notifiers/current_user_notifier.dart';

part 'splash_destination_notifier.g.dart';

@riverpod
Future<String> splashDestinationNotifier(Ref ref) async {
  await Future.delayed(const Duration(seconds: 2));

  final storageService = ref.read(localStorageServiceProvider);
  final isFirstTime = storageService.isFirstTime();
  final user = ref.read(currentUserProvider);

  if (isFirstTime) {
    storageService.markAsNotFirstTime();
    return RouteNames.signup;
  } else if (user != null) {
    return RouteNames.chats;
  } else {
    return RouteNames.login;
  }
}
