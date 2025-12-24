import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';

part 'login_with_google_command.g.dart';

@riverpod
class LoginWithGoogleCommand extends _$LoginWithGoogleCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authApiProvider).googleSignIn(),
    );
  }
}