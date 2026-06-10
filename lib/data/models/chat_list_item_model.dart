// lib/data/models/chat_list_item_model.dart

class ChatListItemModel {
  final String chatId;
  final String chatType; // dm | group | channel | saved
  final String? title;
  final String? description;
  final String? imageUrl;
  final bool isPublic;
  final String? inviteLink;
  final DateTime updatedAt;

  // membership
  final String memberRole;
  final bool isPinned;
  final bool isArchived;
  final bool isMuted;

  // last message
  final String? lastMessageId;
  final String? lastMessageContent;
  final String? lastMessageType;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final String? lastMessageSenderName;

  // unread
  final int unreadCount;

  // DM-only: the other person
  final String? otherUserId;
  final String? otherUserName;
  final String? otherUserImage;

  const ChatListItemModel({
    required this.chatId,
    required this.chatType,
    this.title,
    this.description,
    this.imageUrl,
    required this.isPublic,
    this.inviteLink,
    required this.updatedAt,
    required this.memberRole,
    required this.isPinned,
    required this.isArchived,
    required this.isMuted,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageType,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.lastMessageSenderName,
    required this.unreadCount,
    this.otherUserId,
    this.otherUserName,
    this.otherUserImage,
  });

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      chatId: json['chat_id'] as String,
      chatType: json['chat_type'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      inviteLink: json['invite_link'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      memberRole: json['member_role'] as String? ?? 'member',
      isPinned: json['is_pinned'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
      lastMessageId: json['last_message_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageType: json['last_message_type'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      lastMessageSenderName: json['last_message_sender_name'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      otherUserId: json['other_user_id'] as String?,
      otherUserName: json['other_user_name'] as String?,
      otherUserImage: json['other_user_image'] as String?,
    );
  }

  /// Display name — for DMs uses other user's name; for groups/channels uses title
  String get displayTitle {
    if (chatType == 'dm') return otherUserName ?? 'Unknown';
    if (chatType == 'saved') return 'Saved Messages';
    return title ?? '';
  }

  /// Avatar URL
  String? get avatarUrl {
    if (chatType == 'dm') return otherUserImage;
    return imageUrl;
  }

  /// First letter(s) for avatar fallback
  String get avatarInitials {
    final name = displayTitle;
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Human-readable last message preview
  String get lastMessagePreview {
    if (lastMessageContent == null) return '';
    switch (lastMessageType) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎵 Voice message';
      case 'file':
        return '📎 File';
      default:
        return lastMessageContent!;
    }
  }
}
