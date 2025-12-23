class UserPresenceModel {
  final String userId;
  final bool isOnline;
  final DateTime lastSeenAt;
  final DateTime updatedAt;

  UserPresenceModel({
    required this.userId,
    this.isOnline = false,
    required this.lastSeenAt,
    required this.updatedAt,
  });

  factory UserPresenceModel.fromJson(Map<String, dynamic> json) {
    return UserPresenceModel(
      userId: json['user_id'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_online': isOnline,
      'last_seen_at': lastSeenAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserPresenceModel copyWith({
    String? userId,
    bool? isOnline,
    DateTime? lastSeenAt,
    DateTime? updatedAt,
  }) {
    return UserPresenceModel(
      userId: userId ?? this.userId,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayStatus {
    if (isOnline) return 'online';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeenAt);

    if (difference.inMinutes < 1) return 'last seen just now';
    if (difference.inMinutes < 60) return 'last seen ${difference.inMinutes}m ago';
    if (difference.inHours < 24) return 'last seen ${difference.inHours}h ago';
    if (difference.inDays == 1) return 'last seen yesterday';
    if (difference.inDays < 7) return 'last seen ${difference.inDays}d ago';
    
    return 'last seen recently';
  }
}