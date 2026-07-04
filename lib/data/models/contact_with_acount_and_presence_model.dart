class ContactWithAcountAndPresenceModel {
  final String contactId;
  final String ownerUserId;
  final String? contactUserId;

  final String contactPhone;
  final String? contactFirstName;
  final String? contactLastName;
  final DateTime? addedAt;

  final bool hasAccount; // contact_user_id != null
  final bool isRegisteredUser; // users row exists

  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profileImageUrl;
  final String? bio;
  final bool? isActive;

  final bool isOnline;
  final DateTime? lastSeenAt;

  String get displayName => '$firstName ${lastName ?? ''} ';
  String get contactDisplayName => '$contactFirstName ${contactLastName ?? ''}';
  String get shortDisplayName {
    String res = (firstName != null && firstName!.isNotEmpty)
        ? firstName![0].toUpperCase()
        : '';

    if (lastName != null && lastName!.isNotEmpty) {
      res += lastName![0].toUpperCase();
    }
    return res.isEmpty ? '?' : res;
  }

  String get shortContactDisplayName {
    String res = (contactFirstName != null && contactFirstName!.isNotEmpty)
        ? contactFirstName![0].toUpperCase()
        : '';

    if (contactLastName != null && contactLastName!.isNotEmpty) {
      res += contactLastName![0].toUpperCase();
    }
    return res.isEmpty ? '?' : res;
  }

  ContactWithAcountAndPresenceModel({
    required this.contactId,
    required this.ownerUserId,
    required this.contactUserId,
    required this.contactPhone,
    required this.contactFirstName,
    required this.contactLastName,
    required this.addedAt,
    required this.hasAccount,
    required this.isRegisteredUser,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profileImageUrl,
    required this.bio,
    required this.isActive,
    required this.isOnline,
    required this.lastSeenAt,
  });

  factory ContactWithAcountAndPresenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ContactWithAcountAndPresenceModel(
      contactId: json['contact_id'] as String,
      ownerUserId: json['owner_user_id'] as String,
      contactUserId: json['contact_user_id'] as String?,
      contactPhone: json['contact_phone'] as String,
      contactFirstName: json['contact_first_name'] as String?,
      contactLastName: json['contact_last_name'] as String?,
      addedAt: json['added_at'] != null
          ? DateTime.parse(json['added_at'] as String)
          : null,

      hasAccount: (json['has_account'] as bool?) ?? false,
      isRegisteredUser: (json['is_registered_user'] as bool?) ?? false,

      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      username: json['username'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool?,

      isOnline: (json['is_online'] as bool?) ?? false,
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'] as String)
          : null,
    );
  }
}
