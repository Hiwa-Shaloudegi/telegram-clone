
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/data/api/auth/auth_api.dart';

part 'on_auth_changes_notifier.g.dart';

@riverpod
Stream<AuthState?> onAuthChanges(Ref ref) {
  return ref.read(authApiProvider).onAuthStateChange();
}