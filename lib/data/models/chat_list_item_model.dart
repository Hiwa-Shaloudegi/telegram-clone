import 'package:telegram_clone/data/models/chat_model.dart';

class ChatListItemModel {
  final String id;
  final String chatId;
  final String userId;
  final String? role;
  final bool? isPinned;
  final bool? isArchived;
  final bool? isMuted;
  final String? lastReadMessageId;
  final String? joinedAt;
  final String? leftAt;
  final ChatModel chat;

  ChatListItemModel({
    required this.id,
    required this.chatId,
    required this.userId,
    this.role,
    this.isPinned,
    this.isArchived,
    this.isMuted,
    this.lastReadMessageId,
    this.joinedAt,
    this.leftAt,
    required this.chat,
  });

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      isPinned: json['is_pinned'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
      lastReadMessageId: json['last_read_message_id'] as String?,
      joinedAt: json['joined_at'] as String?,
      leftAt: json['left_at'] as String?,
      chat: ChatModel.fromJson(json['chats']),
    );
  }
}
