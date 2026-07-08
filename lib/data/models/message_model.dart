// lib/data/models/message_model.dart

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String content;
  final String messageType; // text | image | video | file | audio
  final String? mediaUrl;
  final String? replyToMessageId;
  final String? replyToContent;
  final String? replyToSenderName;
  final bool isForwarded;
  final String? forwardedFromChatId;
  final String? forwardedFromTitle;
  final String? forwardedFromSenderId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOwnMessage;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.content,
    required this.messageType,
    this.mediaUrl,
    this.replyToMessageId,
    this.replyToContent,
    this.replyToSenderName,
    required this.isForwarded,
    this.forwardedFromChatId,
    this.forwardedFromTitle,
    this.forwardedFromSenderId,
    required this.createdAt,
    required this.updatedAt,
    required this.isOwnMessage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String? ?? 'Unknown',
      senderImage: json['sender_image'] as String?,
      content: json['content'] as String? ?? '',
      messageType: json['message_type'] as String? ?? 'text',
      mediaUrl: json['media_url'] as String?,
      replyToMessageId: json['reply_to_message_id'] as String?,
      replyToContent: json['reply_to_content'] as String?,
      replyToSenderName: json['reply_to_sender_name'] as String?,
      isForwarded: json['is_forwarded'] as bool? ?? false,
      forwardedFromChatId: json['forwarded_from_chat_id'] as String?,
      forwardedFromTitle: json['forwarded_from_title'] as String?,
      forwardedFromSenderId: json['forwarded_from_sender_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isOwnMessage: json['is_own_message'] as bool? ?? false,
    );
  }

  /// Used when Supabase realtime INSERT event comes in (partial payload)
  factory MessageModel.fromRealtimePayload(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: '', // will be filled after a re-fetch if needed
      senderImage: null,
      content: json['content'] as String? ?? '',
      messageType: json['message_type'] as String? ?? 'text',
      mediaUrl: json['media_url'] as String?,
      replyToMessageId: json['reply_to_message_id'] as String?,
      replyToContent: null,
      replyToSenderName: null,
      isForwarded: json['is_forwarded'] as bool? ?? false,
      forwardedFromChatId: json['forwarded_from_chat_id'] as String?,
      forwardedFromSenderId: json['forwarded_from_sender_id'] as String?,
      forwardedFromTitle: null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isOwnMessage: false, // will be resolved after enrich
    );
  }

  MessageModel copyWith({
    String? senderName,
    String? senderImage,
    bool? isOwnMessage,
    String? replyToContent,
    String? replyToSenderName,
    bool? isForwarded,
    String? forwardedFromChatId,
    String? forwardedFromTitle,
    String? forwardedFromSenderId,
  }) {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      content: content,
      messageType: messageType,
      mediaUrl: mediaUrl,
      replyToMessageId: replyToMessageId,
      replyToContent: replyToContent ?? this.replyToContent,
      replyToSenderName: replyToSenderName ?? this.replyToSenderName,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFromChatId: forwardedFromChatId ?? this.forwardedFromChatId,
      forwardedFromTitle: forwardedFromTitle ?? this.forwardedFromTitle,
      forwardedFromSenderId:
          forwardedFromSenderId ?? this.forwardedFromSenderId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isOwnMessage: isOwnMessage ?? this.isOwnMessage,
    );
  }
}
