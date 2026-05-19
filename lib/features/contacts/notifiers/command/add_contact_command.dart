import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/contacts/contacts_api.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_contacts_query.dart';

part 'add_contact_command.g.dart';

@riverpod
class AddContactCommand extends _$AddContactCommand {
  @override
  FutureOr<bool> build() => false;

  Future<void> run({
    required String phone,
    required String firstName,
    required String? lastName,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final hasAccount = await ref
          .read(contactsApiProvider)
          .addContact(phone: phone, firstName: firstName, lastName: lastName);
      state = AsyncValue.data(hasAccount);
      return hasAccount;
    });

    if (state is AsyncData) {
      // TODO: First update localy, then invalidate.
      ref.invalidate(getContactsQueryProvider, asReload: true);
    }

    link.close();
  }
}
