import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_profile_model.dart';

part 'user_by_id_query.g.dart';

@riverpod
class UserByIdQuery extends _$UserByIdQuery {
  @override
  FutureOr<UserProfileModel> build(String userId) {
    return ref.read(userApiProvider).getUserById(userId);
  }
}
