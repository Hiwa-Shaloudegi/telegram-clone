import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';

part 'user_profile_query.g.dart';

@riverpod
class UserProfileQuery extends _$UserProfileQuery {
  @override
  FutureOr<UserProfileModel?> build() async {
    return await ref.read(userApiProvider).getUserProfile();
  }
}
