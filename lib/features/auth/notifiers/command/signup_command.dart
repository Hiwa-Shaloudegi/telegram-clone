import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';

part 'signup_command.g.dart';

@riverpod
class SignupCommand extends _$SignupCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run(String email, String password) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authApiProvider).signup(email, password),
    );
  }
}
