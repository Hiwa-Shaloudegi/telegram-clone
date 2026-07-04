import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';
import 'package:telegram_clone/features/auth/notifiers/on_auth_changes_notifier.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  ref.watch(onAuthChangesProvider);

  final currentUser = ref.read(authApiProvider).currentUser;
  // when logging in
  // if (currentUser != null) {
  //   ref.read(userProfileQueryProvider.future);
  //   ref.read(getContactsQueryProvider.future);
  // }
  // // when logging out
  // else {
  //   ref.invalidate(userProfileQueryProvider);
  //   ref.invalidate(getContactsQueryProvider);

  //   ref.invalidate(mainUi_selectedChatItemProviderProvider);
  //   ref.invalidate(contactsUi_sortByProvider);
  // }
  return currentUser;
}
