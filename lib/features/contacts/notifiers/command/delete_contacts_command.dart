import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/contacts/contacts_api.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_contacts_query.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';

part 'delete_contacts_command.g.dart';

@riverpod
class DeleteContactsCommand extends _$DeleteContactsCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run() async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    final HashSet<String> contactIds = ref.read(
      contactsUi_selectedContactsProvider,
    );

    if (contactIds.isEmpty) {
      link.close();
      return;
    }

    // For rollback
    final previousContacts = ref.read(getContactsQueryProvider).value;

    // Optimistic update
    ref
        .read(getContactsQueryProvider.notifier)
        .update(
          (contacts) =>
              contacts.where((c) => !contactIds.contains(c.contactId)).toList(),
        );
    final result = await AsyncValue.guard(
      () => ref.watch(contactsApiProvider).bulkDeleteContacts(contactIds),
    );
    state = result;

    // Rollback on failure
    if (result.hasError && previousContacts != null) {
      ref
          .read(getContactsQueryProvider.notifier)
          .update((_) => previousContacts);
    }

    ref.invalidate(getContactsQueryProvider);
    link.close();
  }
}
