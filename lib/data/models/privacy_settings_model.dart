class PrivacySettingsModel {
  final String userId;
  final String bioVisibility;
  final String profileImageVisibility;
  final String lastSeenVisibility;
  final bool showTypingIndicator;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrivacySettingsModel({
    required this.userId,
    this.bioVisibility = 'everyone',
    this.profileImageVisibility = 'everyone',
    this.lastSeenVisibility = 'everyone',
    this.showTypingIndicator = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsModel(
      userId: json['user_id'] as String,
      bioVisibility: json['bio_visibility'] as String? ?? 'everyone',
      profileImageVisibility: json['profile_image_visibility'] as String? ?? 'everyone',
      lastSeenVisibility: json['last_seen_visibility'] as String? ?? 'everyone',
      showTypingIndicator: json['show_typing_indicator'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bio_visibility': bioVisibility,
      'profile_image_visibility': profileImageVisibility,
      'last_seen_visibility': lastSeenVisibility,
      'show_typing_indicator': showTypingIndicator,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PrivacySettingsModel copyWith({
    String? userId,
    String? bioVisibility,
    String? profileImageVisibility,
    String? lastSeenVisibility,
    bool? showTypingIndicator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrivacySettingsModel(
      userId: userId ?? this.userId,
      bioVisibility: bioVisibility ?? this.bioVisibility,
      profileImageVisibility: profileImageVisibility ?? this.profileImageVisibility,
      lastSeenVisibility: lastSeenVisibility ?? this.lastSeenVisibility,
      showTypingIndicator: showTypingIndicator ?? this.showTypingIndicator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}