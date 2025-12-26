import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_ui_state.g.dart';

@riverpod
class LoginUi_isPasswordObscure extends _$LoginUi_isPasswordObscure {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}
