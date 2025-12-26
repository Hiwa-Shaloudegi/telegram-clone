import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state.g.dart';

@riverpod
class IsPasswordObscure extends _$IsPasswordObscure {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class IsRepeatPasswordObscure extends _$IsRepeatPasswordObscure {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}
