import 'package:telegram_clone/data/models/user_profile.dart';

class ChatMemberModel {
  final String id;
  final String chatId;
  final String userId;
  final String role;
  final bool isPinned;
  final bool isArchived;
  final bool isMuted;
  final String? lastReadMessageId;
  final DateTime joinedAt;
  final DateTime? leftAt;
  
  UserProfile? user;

  ChatMemberModel({
    required this.id,
    required this.chatId,
    required this.userId,
    this.role = 'member',
    this.isPinned = false,
    this.isArchived = false,
    this.isMuted = false,
    this.lastReadMessageId,
    required this.joinedAt,
    this.leftAt,
    this.user,
  });

  factory ChatMemberModel.fromJson(Map<String, dynamic> json) {
    return ChatMemberModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String? ?? 'member',
      isPinned: json['is_pinned'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
      lastReadMessageId: json['last_read_message_id'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      leftAt: json['left_at'] != null ? DateTime.parse(json['left_at'] as String) : null,
      user: json['users'] != null ? UserProfile.fromJson(json['users'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'role': role,
      'is_pinned': isPinned,
      'is_archived': isArchived,
      'is_muted': isMuted,
      'last_read_message_id': lastReadMessageId,
      'joined_at': joinedAt.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
    };
  }

  ChatMemberModel copyWith({
    String? id,
    String? chatId,
    String? userId,
    String? role,
    bool? isPinned,
    bool? isArchived,
    bool? isMuted,
    String? lastReadMessageId,
    DateTime? joinedAt,
    DateTime? leftAt,
    UserProfile? user,
  }) {
    return ChatMemberModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isMuted: isMuted ?? this.isMuted,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      user: user ?? this.user,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isActive => leftAt == null;
}