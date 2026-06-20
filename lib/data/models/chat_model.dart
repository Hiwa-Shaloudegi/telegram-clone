import 'package:telegram_clone/app/enums/chat_type.dart';
import 'package:telegram_clone/data/models/message_model.dart';

class ChatModel {
  final String id;
  final ChatType chatType;
  final String? title;
  final String? description;
  final String? imageUrl;
  final bool isPublic;
  final String? inviteLink;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  // bool isPinned;
  // bool isArchived;
  // bool isMuted;
  // String? lastReadMessageId;
  // int unreadCount;
  // MessageModel? lastMessage;

  ChatModel({
    required this.id,
    required this.chatType,
    this.title,
    this.description,
    this.imageUrl,
    this.isPublic = false,
    this.inviteLink,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    // this.isPinned = false,
    // this.isArchived = false,
    // this.isMuted = false,
    // this.lastReadMessageId,
    // this.unreadCount = 0,
    // this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    String title;
    if (json['chat_type'] as String == 'saved') {
      title = "Saved Messages";
    } else {
      title = json['title'] as String;
    }
    return ChatModel(
      id: json['id'] as String,
      chatType: ChatType.values.firstWhere((e) => e.name == json['chat_type']),
      title: title,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      inviteLink: json['invite_link'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_type': chatType,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'is_public': isPublic,
      'invite_link': inviteLink,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    ChatType? chatType,
    String? title,
    String? description,
    String? imageUrl,
    bool? isPublic,
    String? inviteLink,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    bool? isMuted,
    String? lastReadMessageId,
    int? unreadCount,
    MessageModel? lastMessage,
  }) {
    return ChatModel(
      id: id ?? this.id,
      chatType: chatType ?? this.chatType,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isPublic: isPublic ?? this.isPublic,
      inviteLink: inviteLink ?? this.inviteLink,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // isPinned: isPinned ?? this.isPinned,
      // isArchived: isArchived ?? this.isArchived,
      // isMuted: isMuted ?? this.isMuted,
      // lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      // unreadCount: unreadCount ?? this.unreadCount,
      // lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  bool get isPrivate => chatType == ChatType.private;
  bool get isGroup => chatType == ChatType.group;
  bool get isChannel => chatType == ChatType.channel;
  bool get isSaved => chatType == ChatType.saved;
  // bool get hasUnread => unreadCount > 0;
}
