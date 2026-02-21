import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/cache/query_cache_service.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile.dart';

part 'user_profile_query_test.g.dart';

@Riverpod(keepAlive: true)
class UserProfileQueryTest extends _$UserProfileQueryTest {
  @override
  Future<UserProfile> build() async {
    final cache = ref.read(queryCacheServiceProvider);

    // 1️⃣ Emit cached data immediately (no loading)
    // final cached = cache.decode<UserProfile>('user_profile_test_query');
    final cached = null;
    if (cached != null) {
      state = AsyncData(cached);
    }

    // 2️⃣ Fetch fresh data in background
    final fresh = await ref.read(userApiProvider).getUserProfile();

    // 3️⃣ Update cache
    // cache.encode('user_profile_test_query', fresh);

    return fresh;
  }
}
