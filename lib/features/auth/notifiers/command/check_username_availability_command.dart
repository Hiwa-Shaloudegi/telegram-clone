import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';

part 'check_username_availability_command.g.dart';

@riverpod
class CheckUsernameAvailabilityCommand
    extends _$CheckUsernameAvailabilityCommand {
  @override
  FutureOr<bool?> build() {
    return null;
  }

  Future<void> run({required String username}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final isAvailable = await ref
          .read(userApiProvider)
          .isUsernameAvailable(username);
      state = AsyncValue.data(isAvailable);
      return;
    });
  }
}
