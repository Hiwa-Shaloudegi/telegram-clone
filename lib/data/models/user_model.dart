class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String username;
  final String displayName;
  final String? bio;
  final String? profileImageUrl;
  final List<String> additionalImages;
  final String authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.username,
    required this.displayName,
    this.bio,
    this.profileImageUrl,
    this.additionalImages = const [],
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      additionalImages: json['additional_images'] != null
          ? List<String>.from(json['additional_images'] as List)
          : [],
      authProvider: json['auth_provider'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'username': username,
      'display_name': displayName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'additional_images': additionalImages,
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? username,
    String? displayName,
    String? bio,
    String? profileImageUrl,
    List<String>? additionalImages,
    String? authProvider,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String get initials {
    if (displayName.isNotEmpty) {
      final parts = displayName.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName[0].toUpperCase();
    }
    return username.substring(1, 2).toUpperCase();
  }

  String get usernameWithoutAt {
    return username.startsWith('@') ? username.substring(1) : username;
  }

  bool get hasProfileImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;
  bool get hasAdditionalImages => additionalImages.isNotEmpty;
  int get imageCount => (hasProfileImage ? 1 : 0) + additionalImages.length;
}
