import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_clone/core/utils/date_helper.dart';
import 'package:telegram_clone/core/utils/get_color_from_name.dart';
import 'package:telegram_clone/data/models/contact_with_acount_and_presence_model.dart';
import 'package:telegram_clone/features/contacts/notifiers/ui/contacts_ui_state.dart';

class ContactTile extends ConsumerWidget {
  const ContactTile({super.key, required this.contact, this.onTap});

  final ContactWithAcountAndPresenceModel contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectionMode = ref.watch(isSelectionModeProvider);

    final isSelected = ref.watch(
      contactsUi_selectedContactsProvider.select(
        (selected) => selected.contains(contact.contactId),
      ),
    );

    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: isSelectionMode
            ? () => ref
                  .read(contactsUi_selectedContactsProvider.notifier)
                  .toggle(contact.contactId)
            : onTap,
        onLongPress: isSelectionMode
            ? null
            : () => ref
                  .read(contactsUi_selectedContactsProvider.notifier)
                  .toggle(contact.contactId),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (isSelectionMode) ...[
                Checkbox(value: isSelected, onChanged: (_) {}),
                const SizedBox(width: 8),
              ],

              CircleAvatar(
                radius: 24,
                backgroundColor: getColorFromName(
                  contact.contactDisplayName,
                ),
                foregroundImage: contact.profileImageUrl != null
                    ? NetworkImage(contact.profileImageUrl!)
                    : null,
                child: contact.profileImageUrl == null
                    ? Text(
                        contact.shortContactDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.contactDisplayName.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      contact.isOnline
                          ? 'online'
                          : formatLastSeen(contact.lastSeenAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: contact.isOnline
                            ? Colors.green
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),

              if (!contact.hasAccount)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'Invite',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
