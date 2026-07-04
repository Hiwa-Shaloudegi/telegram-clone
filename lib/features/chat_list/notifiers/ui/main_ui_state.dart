import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

part 'main_ui_state.g.dart';

@riverpod
class MainUi_isFabVisible extends _$MainUi_isFabVisible {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class MainUi_selectedChatItemProvider
    extends _$MainUi_selectedChatItemProvider {
  @override
  ChatListItemModel? build() => null;

  void set(ChatListItemModel? value) {
    state = value;
  }
}
