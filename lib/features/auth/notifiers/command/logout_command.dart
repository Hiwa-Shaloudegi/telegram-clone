import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';

part 'logout_command.g.dart';

@riverpod
class LogoutCommand extends _$LogoutCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run() async {
    final link = ref.keepAlive();

    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authApiProvider).logout(),
    );
    link.close();
  }
}