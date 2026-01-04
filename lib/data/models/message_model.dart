import 'package:telegram_clone/data/models/user_profile.dart';

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String? mediaUrl;
  final String? replyToMessageId;
  final bool isForwarded;
  final String? forwardedFromChatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  
  UserProfile? sender;
  MessageModel? replyToMessage;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.messageType = 'text',
    this.mediaUrl,
    this.replyToMessageId,
    this.isForwarded = false,
    this.forwardedFromChatId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.sender,
    this.replyToMessage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      mediaUrl: json['media_url'] as String?,
      replyToMessageId: json['reply_to_message_id'] as String?,
      isForwarded: json['is_forwarded'] as bool? ?? false,
      forwardedFromChatId: json['forwarded_from_chat_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      sender: json['sender'] != null ? UserProfile.fromJson(json['sender'] as Map<String, dynamic>) : null,
      replyToMessage: json['reply_to'] != null ? MessageModel.fromJson(json['reply_to'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
      'media_url': mediaUrl,
      'reply_to_message_id': replyToMessageId,
      'is_forwarded': isForwarded,
      'forwarded_from_chat_id': forwardedFromChatId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    String? messageType,
    String? mediaUrl,
    String? replyToMessageId,
    bool? isForwarded,
    String? forwardedFromChatId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    UserProfile? sender,
    MessageModel? replyToMessage,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFromChatId: forwardedFromChatId ?? this.forwardedFromChatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sender: sender ?? this.sender,
      replyToMessage: replyToMessage ?? this.replyToMessage,
    );
  }

  bool get isDeleted => deletedAt != null;
  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isVideo => messageType == 'video';
  bool get isAudio => messageType == 'audio';
  bool get isFile => messageType == 'file';
  bool get hasReply => replyToMessageId != null;
  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;
}