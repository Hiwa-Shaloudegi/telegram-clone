class MessageForwardModel {
  final String id;
  final String originalMessageId;
  final String forwardedMessageId;
  final String forwardedBy;
  final String forwardedToChatId;
  final DateTime forwardedAt;

  MessageForwardModel({
    required this.id,
    required this.originalMessageId,
    required this.forwardedMessageId,
    required this.forwardedBy,
    required this.forwardedToChatId,
    required this.forwardedAt,
  });

  factory MessageForwardModel.fromJson(Map<String, dynamic> json) {
    return MessageForwardModel(
      id: json['id'] as String,
      originalMessageId: json['original_message_id'] as String,
      forwardedMessageId: json['forwarded_message_id'] as String,
      forwardedBy: json['forwarded_by'] as String,
      forwardedToChatId: json['forwarded_to_chat_id'] as String,
      forwardedAt: DateTime.parse(json['forwarded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_message_id': originalMessageId,
      'forwarded_message_id': forwardedMessageId,
      'forwarded_by': forwardedBy,
      'forwarded_to_chat_id': forwardedToChatId,
      'forwarded_at': forwardedAt.toIso8601String(),
    };
  }

  MessageForwardModel copyWith({
    String? id,
    String? originalMessageId,
    String? forwardedMessageId,
    String? forwardedBy,
    String? forwardedToChatId,
    DateTime? forwardedAt,
  }) {
    return MessageForwardModel(
      id: id ?? this.id,
      originalMessageId: originalMessageId ?? this.originalMessageId,
      forwardedMessageId: forwardedMessageId ?? this.forwardedMessageId,
      forwardedBy: forwardedBy ?? this.forwardedBy,
      forwardedToChatId: forwardedToChatId ?? this.forwardedToChatId,
      forwardedAt: forwardedAt ?? this.forwardedAt,
    );
  }
}