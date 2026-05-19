class UserProfileModel {
  final String id;
  final String? email;
  final String? phone;
  final String? username;
  final String firstName;
  final String? lastName;
  final String? bio;
  final String? profileImageUrl;
  final List<String> additionalImages;
  final String authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime? birthday;

  String get displayName => '$firstName $lastName'.trim();
  String get shortDisplayName {
    final nameList = displayName.split(' ');
    final f = nameList[0][0].toUpperCase();
    if (nameList.length > 1) {
      final l = nameList[1][0].toUpperCase();
      return '$f$l';
    }
    return f;
  }

  UserProfileModel({
    required this.id,
    this.email,
    this.phone,
    this.username,
    required this.firstName,
    this.lastName,
    this.bio,
    this.profileImageUrl,
    this.additionalImages = const [],
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.birthday,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      username: json['username'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      additionalImages: json['additional_images'] != null
          ? List<String>.from(json['additional_images'] as List)
          : [],
      authProvider: json['auth_provider'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'additional_images': additionalImages,
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'birthday': birthday?.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    String? profileImageUrl,
    List<String>? additionalImages,
    String? authProvider,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    DateTime? birthday,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      birthday: birthday ?? this.birthday,
    );
  }

  // String get initials {
  //   if (displayName.isNotEmpty) {
  //     final parts = displayName.trim().split(' ');
  //     if (parts.length >= 2) {
  //       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  //     }
  //     return displayName[0].toUpperCase();
  //   }
  //   return email?.substring(0, 1).toUpperCase() ?? 'U';
  // }

  String? get usernameWithoutAt {
    if (username == null) return null;
    return username!.startsWith('@') ? username!.substring(1) : username;
  }

  bool get hasProfileImage =>
      profileImageUrl != null && profileImageUrl!.isNotEmpty;
  bool get hasAdditionalImages => additionalImages.isNotEmpty;
  int get imageCount => (hasProfileImage ? 1 : 0) + additionalImages.length;
}
