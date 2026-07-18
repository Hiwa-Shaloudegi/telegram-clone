import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/storage/storage_api.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';
import 'package:telegram_clone/features/profile/notifiers/query/user_profile_query.dart';

part 'update_profile_command.g.dart';

@riverpod
class UpdateProfileCommand extends _$UpdateProfileCommand {
  @override
  FutureOr<void> build() {}

  /// Updates profile fields and/or profile photo.
  ///
  /// [removePhoto] removes the current profile image.
  /// [localImage] uploads and sets a new profile image.
  Future<UserProfileModel> run({
    String? firstName,
    String? lastName,
    String? bio,
    String? username,
    bool clearUsername = false,
    XFile? localImage,
    bool removePhoto = false,
  }) async {
    state = const AsyncValue.loading();

    late UserProfileModel result;

    state = await AsyncValue.guard(() async {
      final userApi = ref.read(userApiProvider);

      final hasFieldUpdates =
          firstName != null ||
          lastName != null ||
          bio != null ||
          username != null ||
          clearUsername;

      if (hasFieldUpdates) {
        result = await userApi.updateProfile(
          firstName: firstName,
          lastName: lastName,
          bio: bio,
          username: username,
          clearUsername: clearUsername,
        );
      }

      if (localImage != null) {
        final storageApi = ref.read(storageApiProvider);
        final imageUrl = await storageApi.uploadProfileImage(localImage);
        result = await userApi.updateProfileImage(imageUrl);
      } else if (removePhoto) {
        result = await userApi.removeProfileImage();
      } else if (!hasFieldUpdates) {
        result = await userApi.getUserProfile();
      }

      ref.invalidate(userProfileQueryProvider);
    });

    if (state.hasError) {
      throw state.error!;
    }

    return result;
  }
}
