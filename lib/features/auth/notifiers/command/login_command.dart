import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';

part 'login_command.g.dart';

@riverpod
class LoginCommand extends _$LoginCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run(String email, String password) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authApiProvider).login(email, password),
    );
  }
}