import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';

part 'complete_profile_command.g.dart';

@riverpod
class CompleteProfileCommand extends _$CompleteProfileCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String displayName,
    // File? profileImage,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userApi = ref.read(userApiProvider);
      await userApi.updateProfile(displayName: displayName);

      // Upload profile image if provided
      // if (profileImage != null) {
      //   final storageApi = ref.read(storageApiProvider);
      //   final imageUrl = await storageApi.uploadProfileImage(profileImage);
      //   await userApi.updateProfileImage(imageUrl);
      // }
    });
  }
}
