import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chat_api.dart';
import 'package:telegram_clone/data/models/chat_model.dart';

part 'get_user_chats_query.g.dart';

@Riverpod()
class GetUserChatsQuery extends _$GetUserChatsQuery {
  @override
  FutureOr<List<ChatModel>> build() async {
    final chatApi = ref.read(chatApiProvider);
    return await chatApi.getUserChats();
  }
}
