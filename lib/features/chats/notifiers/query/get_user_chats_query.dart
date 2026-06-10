import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';
import 'package:telegram_clone/data/models/chat_list_item_model.dart';

part 'get_user_chats_query.g.dart';

@riverpod
Stream<List<ChatListItemModel>> getUserChatsQuery(Ref ref) {
  return ref.read(chatsApiProvider).watchUserChats();
}
