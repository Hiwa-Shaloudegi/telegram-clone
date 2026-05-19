import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/contacts/contacts_api.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';

part 'get_contacts_query.g.dart';

@Riverpod(keepAlive: true)
class GetContactsQuery extends _$GetContactsQuery {
  @override
  FutureOr<List<ContactWithAcountAndPresenceModel>> build() async {
    return await ref.read(contactsApiProvider).fetchContacts();
  }
}

@riverpod
List<ContactWithAcountAndPresenceModel> contactsWithAccount(Ref ref) {
  return ref
      .watch(getContactsQueryProvider)
      .when(
        data: (allContacts) => allContacts.where((c) => c.hasAccount).toList(),

        loading: () => [],
        error: (_, _) => [],
      );
}

@riverpod
List<ContactWithAcountAndPresenceModel> contactsWithoutAccount(Ref ref) {
  return ref
      .watch(getContactsQueryProvider)
      .when(
        data: (allContacts) => allContacts.where((c) => !c.hasAccount).toList(),
        loading: () => [],
        error: (_, _) => [],
      );
}
