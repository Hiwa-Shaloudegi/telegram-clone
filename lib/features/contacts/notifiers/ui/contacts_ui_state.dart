import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_ui_state.g.dart';

enum ContactsSortBy { alphabet, lastSeen }

@Riverpod(keepAlive: true)
class ContactsUi_sortBy extends _$ContactsUi_sortBy {
  @override
  ContactsSortBy build() => ContactsSortBy.alphabet;

  void set(ContactsSortBy value) {
    state = value;
  }

  void toggle() {
    state = state == ContactsSortBy.alphabet
        ? ContactsSortBy.lastSeen
        : ContactsSortBy.alphabet;
  }
}

@riverpod
class ContactsUi_selectedContacts extends _$ContactsUi_selectedContacts {
  @override
  HashSet<String> build() => HashSet<String>();

  void clear() {
    state = HashSet<String>();
  }

  void toggle(String contactId) {
    final newState = HashSet<String>.of(state);

    if (newState.contains(contactId)) {
      newState.remove(contactId);
    } else {
      newState.add(contactId);
    }

    state = newState;
  }
}

@riverpod
bool isSelectionMode(Ref ref) {
  return ref.watch(contactsUi_selectedContactsProvider).isNotEmpty;
}
