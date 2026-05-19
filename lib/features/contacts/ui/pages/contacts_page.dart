import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/core/ui/widgets/section_divider.dart';
import 'package:telegram_clone/features/contacts/ui/widgets/add_contact_bottom_sheet.dart';
import 'package:telegram_clone/features/contacts/ui/widgets/contacts_list.dart';
import 'package:telegram_clone/features/contacts/ui/widgets/new_contacts_action_tile.dart';

class ContactsPage extends ConsumerStatefulWidget {
  final ContactsPageExtra extra;
  const ContactsPage({super.key, required this.extra});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.extra.isOnlyAddContacts ? 'Contacts' : 'New Messages',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddContactBottomSheet(context),
        child: Icon(Icons.person_add_outlined),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.extra.isOnlyAddContacts)
            NewContactsActionTile(
              title: 'Invite Friends',
              icon: Icons.person_add_outlined,
              onTap: () => showAddContactBottomSheet(context),
            )
          else ...[
            NewContactsActionTile(
              title: 'New Group',
              icon: Icons.group,
              onTap: () {},
            ),
            NewContactsActionTile(
              title: 'New Channel',
              icon: Icons.add,
              onTap: () {},
            ),
          ],
          SectionDivider(),
          Expanded(child: ContactsList()),
        ],
      ),
    );
  }
}
