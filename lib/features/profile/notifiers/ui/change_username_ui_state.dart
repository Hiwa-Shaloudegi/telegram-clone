import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_username_ui_state.g.dart';

enum UsernameStatus { idle, checking, available, taken, invalid }

@riverpod
class ChangeUsername_status extends _$ChangeUsername_status {
  @override
  UsernameStatus build() => UsernameStatus.idle;

  void set(UsernameStatus value) => state = value;
}

@riverpod
class ChangeUsername_statusMessage extends _$ChangeUsername_statusMessage {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}
