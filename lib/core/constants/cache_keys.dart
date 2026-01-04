
abstract class CacheKeys {
  static const String _prefix = 'query_cache_';
  
  static const String currentUser = '${_prefix}current_user';
  
  static String userProfile(String userId) => '${_prefix}user_$userId';
  static String chatList = '${_prefix}chat_list';
  static String chat(String chatId) => '${_prefix}chat_$chatId';
}
