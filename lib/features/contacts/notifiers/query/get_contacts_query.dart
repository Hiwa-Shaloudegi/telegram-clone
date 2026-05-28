import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/contacts/contacts_api.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';

part 'get_contacts_query.g.dart';

@Riverpod(keepAlive: true)
class GetContactsQuery extends _$GetContactsQuery {
  @override
  FutureOr<List<ContactWithAcountAndPresenceModel>> build() async {
    return await ref.read(contactsApiProvider).fetchContacts();
  }

  void set(
    List<ContactWithAcountAndPresenceModel> Function(
      List<ContactWithAcountAndPresenceModel> contacts,
    )
    cb,
  ) {
    final current = state.value;

    if (current == null) return;

    state = AsyncData(cb(current));
  }
}

@riverpod
List<ContactWithAcountAndPresenceModel> contactsWithAccount(Ref ref) {
  final sortBy = ref.watch(contactsUi_sortByProvider);

  return ref
      .watch(getContactsQueryProvider)
      .when(
        data: (allContacts) {
          final filtered = allContacts.where((c) => c.hasAccount).toList();
          return _sortContacts(filtered, sortBy);
        },
        loading: () => [],
        error: (_, _) => [],
      );
}

@riverpod
List<ContactWithAcountAndPresenceModel> contactsWithoutAccount(Ref ref) {
  final sortBy = ref.watch(contactsUi_sortByProvider);

  return ref
      .watch(getContactsQueryProvider)
      .when(
        data: (allContacts) {
          final filtered = allContacts.where((c) => !c.hasAccount).toList();
          return _sortContacts(filtered, sortBy);
        },
        loading: () => [],
        error: (_, _) => [],
      );
}

List<ContactWithAcountAndPresenceModel> _sortContacts(
  List<ContactWithAcountAndPresenceModel> list,
  ContactsSortBy sortBy,
) {
  final sortedList = List<ContactWithAcountAndPresenceModel>.from(list);

  if (sortBy == ContactsSortBy.alphabet) {
    sortedList.sort((a, b) {
      final nameA = a.contactFirstName?.toLowerCase() ?? '';
      final nameB = b.contactFirstName?.toLowerCase() ?? '';
      return nameA.compareTo(nameB);
    });
  } else if (sortBy == ContactsSortBy.lastSeen) {
    sortedList.sort((a, b) {
      final dateA = a.lastSeenAt ?? DateTime(0);
      final dateB = b.lastSeenAt ?? DateTime(0);
      return dateB.compareTo(dateA);
    });
  }

  return sortedList;
}
