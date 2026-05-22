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
