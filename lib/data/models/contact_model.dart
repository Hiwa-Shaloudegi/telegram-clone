import 'package:telegram_clone/data/models/user_presence_model.dart';
import 'package:telegram_clone/data/models/user_profile.dart';

class ContactModel {
  final String id;
  final String userId;
  final String contactUserId;
  final DateTime addedAt;

  UserProfile? contact;
  UserPresenceModel? presence;

  ContactModel({
    required this.id,
    required this.userId,
    required this.contactUserId,
    required this.addedAt,
    this.contact,
    this.presence,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      contactUserId: json['contact_user_id'] as String,
      addedAt: DateTime.parse(json['added_at'] as String),
      contact: json['contact'] != null
          ? UserProfile.fromJson(json['contact'] as Map<String, dynamic>)
          : null,
      presence: json['presence'] != null
          ? UserPresenceModel.fromJson(json['presence'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'contact_user_id': contactUserId,
      'added_at': addedAt.toIso8601String(),
    };
  }

  ContactModel copyWith({
    String? id,
    String? userId,
    String? contactUserId,
    DateTime? addedAt,
    UserProfile? contact,
    UserPresenceModel? presence,
  }) {
    return ContactModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contactUserId: contactUserId ?? this.contactUserId,
      addedAt: addedAt ?? this.addedAt,
      contact: contact ?? this.contact,
      presence: presence ?? this.presence,
    );
  }

  bool get isOnline => presence?.isOnline ?? false;
}
