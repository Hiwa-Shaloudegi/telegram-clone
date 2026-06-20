import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/models/message_model.dart';

part 'chat_ui_state.g.dart';

@riverpod
class ChatUi_replyingTo extends _$ChatUi_replyingTo {
  @override
  MessageModel? build() => null;

  void set(MessageModel? value) {
    state = value;
  }
}

@riverpod
class ChatUi_isRecording extends _$ChatUi_isRecording {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class ChatUi_recordingPath extends _$ChatUi_recordingPath {
  @override
  String? build() => '';

  void set(String? value) {
    state = value;
  }
}

@riverpod
class ChatUi_hasText extends _$ChatUi_hasText {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class ChatUi_selectedMessages extends _$ChatUi_selectedMessages {
  @override
  HashSet<String> build() => HashSet<String>();

  void clear() {
    state = HashSet<String>();
  }

  void toggle(String messageId) {
    final newState = HashSet<String>.of(state);

    if (newState.contains(messageId)) {
      newState.remove(messageId);
    } else {
      newState.add(messageId);
    }

    state = newState;
  }
}

@riverpod
bool ChatUi_isSelectionMode(Ref ref) {
  return ref.watch(chatUi_selectedMessagesProvider).isNotEmpty;
}
