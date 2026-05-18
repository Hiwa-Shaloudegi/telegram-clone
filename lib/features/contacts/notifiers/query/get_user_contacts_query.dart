import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/contacts/contacts_api.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';

part 'get_user_contacts_query.g.dart';

@riverpod
class GetUserContactsQuery extends _$GetUserContactsQuery {
  @override
  FutureOr<List<ContactWithAcountAndPresenceModel>> build() async {
    return await ref.read(contactsApiProvider).fetchContacts();
  }
}
