import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_profile_ui_state.g.dart';

@riverpod
class EditProfile_localImage extends _$EditProfile_localImage {
  @override
  XFile? build() => null;

  void set(XFile? value) => state = value;
}

@riverpod
class EditProfile_photoRemoved extends _$EditProfile_photoRemoved {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

@riverpod
class EditProfile_initialized extends _$EditProfile_initialized {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

@riverpod
class EditProfile_currentUsername extends _$EditProfile_currentUsername {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

@riverpod
class EditProfile_changeTick extends _$EditProfile_changeTick {
  @override
  int build() => 0;

  void tick() => state++;
}
