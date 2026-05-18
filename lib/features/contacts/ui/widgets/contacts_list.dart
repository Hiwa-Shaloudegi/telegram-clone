import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_user_contacts_query.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(getUserContactsQueryProvider);

    return contactsAsync.when(
      data: (contacts) {
        if (contacts.isEmpty) {
          return Center(child: Text('No contacts found.'));
        } else {
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: SizedBox(
                    child: CircleAvatar(
                      child: contact.profileImageUrl == null
                          ? Center(
                              child: Text(
                                '${contact.contactFirstName?.substring(0, 1).toUpperCase()}',
                              ),
                            )
                          : Image.network(contact.profileImageUrl ?? ''),
                    ),
                  ),
                ),
                title: Text(
                  contact.contactFirstName ?? 'Unknown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contact.isOnline
                      ? 'online'
                      : contact.lastSeenAt != null
                      ? 'last seen ${contact.lastSeenAt}'
                      : 'offline',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {},
              );
            },
          );
        }
      },
      error: (error, stackTrace) => Center(
        child: Column(
          children: [Text('Failed to load contacts'), SizedBox(height: 8)],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
