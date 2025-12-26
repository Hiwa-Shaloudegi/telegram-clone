import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_ui_state.g.dart';

@riverpod
class SignupUi_isPasswordObscure extends _$SignupUi_isPasswordObscure {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class SignupUi_isRepeatPasswordObscure extends _$SignupUi_isRepeatPasswordObscure {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}
