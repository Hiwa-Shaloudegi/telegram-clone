import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_ui_state.g.dart';

@riverpod
class MainUi_isFabVisible extends _$MainUi_isFabVisible {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}
