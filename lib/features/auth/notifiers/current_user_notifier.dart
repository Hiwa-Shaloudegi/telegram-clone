import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';
import 'package:telegram_clone/features/auth/notifiers/on_auth_changes_notifier.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  ref.watch(onAuthChangesProvider);
  return ref.read(authApiProvider).currentUser;
}
