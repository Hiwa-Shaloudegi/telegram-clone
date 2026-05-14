import 'package:telegram_clone/data/models/privacy_settings_model.dart';

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

  bool get isActuallyOnline {
    if (!isOnline) return false;
    // Timeout Mechanism:
    // If "last seen" was more than 5 minutes ago, we consider them offline
    // even if the DB says "is_online: true".
    // This handles crash/kill scenarios where the user couldn't send an "offline" signal.
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    return lastSeenAt.isAfter(cutoff);
  }

  String getDisplayStatus(PrivacySettingsModel? privacy) {
    // 1. Privacy Check
    if (privacy != null) {
      if (privacy.lastSeenVisibility == 'nobody') {
        return 'last seen recently';
      }
      // 'contacts' logic would go here (requires checking relationship)
    }

    // 2. Reliability Check (Timeout)
    if (isActuallyOnline) return 'online';

    final now = DateTime.now();
    final difference = now.difference(lastSeenAt);

    if (difference.inMinutes < 1) return 'last seen just now';
    if (difference.inMinutes < 60)
      return 'last seen ${difference.inMinutes}m ago';
    if (difference.inHours < 24) return 'last seen ${difference.inHours}h ago';
    if (difference.inDays == 1) return 'last seen yesterday';
    if (difference.inDays < 7) return 'last seen ${difference.inDays}d ago';

    return 'last seen recently';
  }
}
