class ChatFolderModel {
  final String id;
  final String userId;
  final String name;
  final int position;
  final DateTime createdAt;
  final List<String> chatIds;

  const ChatFolderModel({
    required this.id,
    required this.userId,
    required this.name,
    this.position = 0,
    required this.createdAt,
    this.chatIds = const [],
  });

  int get chatCount => chatIds.length;
  bool get isEmpty => chatIds.isEmpty;
  bool get hasChats => chatIds.isNotEmpty;

  factory ChatFolderModel.fromJson(Map<String, dynamic> json) {
    final items = json['user_chat_folders'];
    final chatIds = <String>[];

    if (items is List) {
      for (final item in items) {
        if (item is Map<String, dynamic>) {
          final chatId = item['chat_id'] as String?;
          if (chatId != null) chatIds.add(chatId);
        }
      }
    } else if (json['chat_ids'] is List) {
      for (final id in json['chat_ids'] as List) {
        if (id is String) chatIds.add(id);
      }
    }

    return ChatFolderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      position: json['position'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      chatIds: chatIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'position': position,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  ChatFolderModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? position,
    DateTime? createdAt,
    List<String>? chatIds,
  }) {
    return ChatFolderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      chatIds: chatIds ?? this.chatIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatFolderModel &&
        other.id == id &&
        other.name == name &&
        other.position == position &&
        _listEquals(other.chatIds, chatIds);
  }

  @override
  int get hashCode => Object.hash(id, name, position, Object.hashAll(chatIds));
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
