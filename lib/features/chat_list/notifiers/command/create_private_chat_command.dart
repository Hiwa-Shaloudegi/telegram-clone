import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telegram_clone/core/constants/route_names.dart';
import 'package:telegram_clone/data/api/chat/chats_api.dart';

part 'create_private_chat_command.g.dart';

@riverpod
class CreatePrivateChatCommand extends _$CreatePrivateChatCommand {
  @override
  FutureOr<void> build() {}

  Future<void> run({
    required String otherUserId,
    required GoRouter router,
  }) async {
    final link = ref.keepAlive();
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final chatId = await ref
          .read(chatsApiProvider)
          .getOrCreatePrivateChat(otherUserId);

      router.pushNamed(
        RouteNames.chat,
        pathParameters: {'chatId': chatId},
      );
    });

    link.close();
  }
}
