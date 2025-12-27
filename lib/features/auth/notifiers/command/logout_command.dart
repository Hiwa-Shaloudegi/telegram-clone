import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';
import 'package:telegram_clone/services/presence_service.dart';

part 'logout_command.g.dart';

@riverpod
class LogoutCommand extends _$LogoutCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run() async {
    final link = ref.keepAlive();

    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(presenceServiceProvider.notifier).goOffline();
      return ref.read(authApiProvider).logout();
    });
    link.close();
  }
}