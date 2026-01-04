import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/cache/cached_query_mixin.dart';
import 'package:telegram_clone/core/constants/cache_keys.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile.dart';
import 'package:telegram_clone/features/auth/notifiers/on_auth_changes_notifier.dart';

part 'user_profile_query.g.dart';

@Riverpod(keepAlive: true)
class UserProfileQuery extends _$UserProfileQuery with CachedQueryMixin<UserProfile> {
  @override
  String get cacheKey => CacheKeys.currentUser;

  @override
  UserProfile fromJson(Map<String, dynamic> json) => UserProfile.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserProfile data) => data.toJson();

  @override
  Future<UserProfile> fetchFromNetwork() {
    return ref.read(userApiProvider).getUserProfile();
  }

  @override
  FutureOr<UserProfile> build() {
    // Watch for auth changes to automatically react
    final authState = ref.watch(onAuthChangesProvider).asData?.value;

    // If user signs out, clear the cache
    if (authState?.event == AuthChangeEvent.signedOut) {
      invalidateCache();
    }

    // Only proceed if we have an authenticated user
    // The userApi expects a logged in user
    return buildCached();
  }
}
