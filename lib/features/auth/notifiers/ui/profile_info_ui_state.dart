import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_info_ui_state.g.dart';

@riverpod
class ProfileInfoUi_selectedProfileImage
    extends _$ProfileInfoUi_selectedProfileImage {
  @override
  XFile? build() => null;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      state = pickedFile;
    }
  }
}
