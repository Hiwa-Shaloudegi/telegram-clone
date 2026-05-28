import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/app/router/extra/contacts_page_extra.dart';
import 'package:telegram_clone/features/contacts/notifiers/command/delete_contacts_command.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';

class ContactsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ContactsAppBar({super.key, required this.extra});
  final ContactsPageExtra extra;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final selectedCounts = ref
        .watch(contactsUi_selectedContactsProvider)
        .length;

    return AppBar(
      automaticallyImplyLeading: !isSelectionMode,
      title: isSelectionMode
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(contactsUi_selectedContactsProvider.notifier)
                      .clear(),
                  icon: Icon(Icons.close),
                ),
                SizedBox(width: 8),
                Text('$selectedCounts selected'),
              ],
            )
          : Text(
              extra.isOnlyAddContacts ? 'Contacts' : 'New Messages',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
      actions: [
        if (isSelectionMode)
          IconButton(
            onPressed: () {
              // ref.read(deleteContactsCommandProvider.notifier).run();
              // show confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: selectedCounts == 1
                        ? Text('Delete Contact')
                        : Text('Delete $selectedCounts Contacts'),
                    content: selectedCounts == 1
                        ? Text('Are you sure you want to delete this contact?')
                        : Text(
                            'Are you sure you want to delete these contacts?',
                          ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ref
                              .read(
                                contactsUi_selectedContactsProvider.notifier,
                              )
                              .clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(deleteContactsCommandProvider.notifier)
                              .run();
                          Navigator.of(context).pop();
                          ref
                              .read(
                                contactsUi_selectedContactsProvider.notifier,
                              )
                              .clear();
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          )
        else ...[
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(contactsUi_sortByProvider.notifier).toggle();
                },
                icon: Icon(Icons.sort),
              ),
              Positioned(
                bottom: 0,
                right: 2,
                child: Consumer(
                  builder: (_, ref, _) {
                    final sortBy = ref.watch(contactsUi_sortByProvider);
                    return switch (sortBy) {
                      ContactsSortBy.alphabet => Icon(
                        Icons.sort_by_alpha,
                        size: 18,
                      ),

                      ContactsSortBy.lastSeen => Icon(
                        Icons.timelapse_outlined,
                        size: 18,
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
