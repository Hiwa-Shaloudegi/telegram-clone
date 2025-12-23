class ChatFolderModel {
  final String id;
  final String userId;
  final String name;
  final int position;
  final DateTime createdAt;
  
  List<String> chatIds;
  int chatCount;

  ChatFolderModel({
    required this.id,
    required this.userId,
    required this.name,
    this.position = 0,
    required this.createdAt,
    this.chatIds = const [],
    this.chatCount = 0,
  });

  factory ChatFolderModel.fromJson(Map<String, dynamic> json) {
    return ChatFolderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      position: json['position'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'position': position,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatFolderModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? position,
    DateTime? createdAt,
    List<String>? chatIds,
    int? chatCount,
  }) {
    return ChatFolderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      chatIds: chatIds ?? this.chatIds,
      chatCount: chatCount ?? this.chatCount,
    );
  }

  bool get isEmpty => chatCount == 0;
  bool get hasChats => chatCount > 0;
}