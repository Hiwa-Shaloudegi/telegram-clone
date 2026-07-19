import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/features/contacts/notifiers/query/get_contacts_query.dart';

part 'contact_name_map_provider.g.dart';

@riverpod
Map<String, String> contactNameMap(Ref ref) {
  return ref.watch(getContactsQueryProvider).when(
        data: (contacts) {
          final map = <String, String>{};
          for (final c in contacts) {
            if (c.hasAccount && c.contactUserId != null) {
              final name = c.contactDisplayName.trim();
              if (name.isNotEmpty) {
                map[c.contactUserId!] = name;
              }
            }
          }
          return map;
        },
        loading: () => {},
        error: (_, _) => {},
      );
}
