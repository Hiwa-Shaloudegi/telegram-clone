import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/cache/cached_query_mixin.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile.dart';

part 'user_profile_query.g.dart';

@Riverpod(keepAlive: true)
class UserProfileQuery extends _$UserProfileQuery with CachedQueryMixin<UserProfile> {
  @override
  String get cacheKey => 'userProfileQuery';

  @override
  FutureOr<UserProfile> build() async {
    return await buildWithCache(
      fetcher: () => ref.read(userApiProvider).getUserProfile(),
      fromJson: (json) => UserProfile.fromJson(json),
      toJson: (data) => data.toJson(),
    );
  }
}
