import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_ui_state.g.dart';

@riverpod
class ChatsUi_isFabVisible extends _$ChatsUi_isFabVisible {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}
