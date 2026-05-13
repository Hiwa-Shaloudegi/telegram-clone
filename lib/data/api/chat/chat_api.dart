import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telegram_clone/core/exception/app_exception.dart';
import 'package:telegram_clone/core/exception/exception_handler.dart';
import 'package:telegram_clone/data/models/chat_model.dart';
import 'package:telegram_clone/services/supabase_client.dart';

part 'chat_api.g.dart';

@Riverpod(keepAlive: true)
ChatApi chatApi(Ref ref) {
  return ChatApi(
    supabase: ref.read(supabaseProvider),
    exceptionHandler: ref.read(exceptionHandlerProvider),
  );
}

class ChatApi {
  final SupabaseClient supabase;
  final ExceptionHandler exceptionHandler;

  ChatApi({required this.supabase, required this.exceptionHandler});

  String? get _currentUserId =>
      supabase.auth.currentUser?.id ?? supabase.auth.currentSession?.user.id;

  Future<List<ChatModel>> getUserChats() async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw AppException(message: 'No authenticated user');
      }

      final response = await supabase
          .from('chat_members')
          .select('*, chats(*)')
          .eq('user_id', userId);

      Logger().i('Chat API Response: $response');

      return (response as List)
          .map((json) => ChatModel.fromJson(json))
          .toList();
    } catch (e) {
      exceptionHandler.handle(e);
    }
  }
}
