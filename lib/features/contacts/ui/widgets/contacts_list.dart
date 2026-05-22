import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/core/utils/date_helper.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_contacts_query.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(getContactsQueryProvider);

    return contactsAsync.when(
      data: (contacts) {
        if (contacts.isEmpty) {
          return const Center(child: Text('No contacts found.'));
        }

        final withAccount = ref.watch(contactsWithAccountProvider);
        final withoutAccount = ref.watch(contactsWithoutAccountProvider);

        // Calculate total count: (List 1) + (Divider) + (List 2)
        // Only include divider if both lists have items.
        final bool showDivider =
            withAccount.isNotEmpty && withoutAccount.isNotEmpty;
        final int itemCount =
            withAccount.length + (showDivider ? 1 : 0) + withoutAccount.length;

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // 1. Logic for the first list
            if (index < withAccount.length) {
              return _buildContactTile(withAccount[index]);
            }

            // 2. Logic for the Divider
            if (showDivider && index == withAccount.length) {
              return SectionDivider(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 3, bottom: 3),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final sortBy = ref.watch(contactsUi_sortByProvider);
                          late String msg;
                          switch (sortBy) {
                            case ContactsSortBy.alphabet:
                              msg = 'name';
                              break;
                            case ContactsSortBy.lastSeen:
                              msg = 'last seen time';
                              break;
                          }
                          return Text(
                            'Sorted by $msg',
                            style: TextStyle(fontSize: 13),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            // 3. Logic for the second list
            final secondListIndex = showDivider
                ? index - withAccount.length - 1
                : index - withAccount.length;
            return _buildContactTile(withoutAccount[secondListIndex]);
          },
        );
      },
      error: (e, st) => const Center(child: Text('Failed to load contacts')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildContactTile(ContactWithAcountAndPresenceModel contact) {
    return ListTile(
      leading: Transform.scale(
        scale: 1.11,
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CircleAvatar(
            foregroundImage: contact.profileImageUrl == null
                ? null
                : NetworkImage(contact.profileImageUrl!),
            child: contact.profileImageUrl == null
                ? Text(contact.shortContactDisplayName)
                : null,
          ),
        ),
      ),
      title: Text(
        contact.contactDisplayName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        contact.isOnline ? 'online' : formatLastSeen(contact.lastSeenAt),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: contact.hasAccount
          ? null
          : TextButton(onPressed: () {}, child: Text('Invite Friend')),
      onTap: () {},
    );
  }
}
