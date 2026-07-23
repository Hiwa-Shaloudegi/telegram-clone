import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/user/user_api.dart';
import 'package:telegram_clone/data/models/user_presence_model.dart';

part 'user_presence_query.g.dart';

@riverpod
class UserPresenceQuery extends _$UserPresenceQuery {
  @override
  Stream<UserPresenceModel?> build(String userId) {
    return ref.read(userApiProvider).watchUserPresence(userId);
  }
}
