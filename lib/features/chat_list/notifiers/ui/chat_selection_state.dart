import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

part 'chat_selection_state.g.dart';

@riverpod
class ChatSelection extends _$ChatSelection {
  @override
  Map<String, ChatListItemModel> build() => const {};

  void clear() {
    state = const {};
  }

  void toggle(ChatListItemModel item) {
    final next = Map<String, ChatListItemModel>.of(state);
    if (next.containsKey(item.chatId)) {
      next.remove(item.chatId);
    } else {
      next[item.chatId] = item;
    }
    state = next;
  }

  bool isSelected(String chatId) => state.containsKey(chatId);
}

@riverpod
bool chatSelectionActive(Ref ref) {
  return ref.watch(chatSelectionProvider).isNotEmpty;
}

@riverpod
bool chatSelectionAllPinned(Ref ref) {
  final items = ref.watch(chatSelectionProvider).values;
  if (items.isEmpty) return false;
  return items.every((i) => i.isPinned);
}

@riverpod
bool chatSelectionAllArchived(Ref ref) {
  final items = ref.watch(chatSelectionProvider).values;
  if (items.isEmpty) return false;
  return items.every((i) => i.isArchived);
}

/// "Block user" is only reasonable when every selected chat is a DM.
@riverpod
bool chatSelectionOnlyDms(Ref ref) {
  final items = ref.watch(chatSelectionProvider).values;
  if (items.isEmpty) return false;
  return items.every((i) => i.chatType == ChatType.private);
}
