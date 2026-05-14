import 'package:telegram_clone/data/models/user_profile.dart';

class TypingIndicatorModel {
  final String id;
  final String chatId;
  final String userId;
  final DateTime startedAt;
  final DateTime expiresAt;

  UserProfile? user;

  TypingIndicatorModel({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.startedAt,
    required this.expiresAt,
    this.user,
  });

  factory TypingIndicatorModel.fromJson(Map<String, dynamic> json) {
    return TypingIndicatorModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      user: json['users'] != null
          ? UserProfile.fromJson(json['users'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'started_at': startedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  TypingIndicatorModel copyWith({
    String? id,
    String? chatId,
    String? userId,
    DateTime? startedAt,
    DateTime? expiresAt,
    UserProfile? user,
  }) {
    return TypingIndicatorModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      user: user ?? this.user,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => !isExpired;
}
