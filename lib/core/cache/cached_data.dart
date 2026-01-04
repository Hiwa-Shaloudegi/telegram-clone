
import 'dart:convert';

class CachedData<T> {
  final T data;
  final DateTime cachedAt;

  CachedData({
    required this.data,
    required this.cachedAt,
  });

  bool isExpired(Duration staleDuration) {
    return DateTime.now().difference(cachedAt) > staleDuration;
  }

  factory CachedData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return CachedData(
      data: fromJsonT(json['data'] as Map<String, dynamic>),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': toJsonT(data),
      'cachedAt': cachedAt.toIso8601String(),
    };
  }

  static CachedData<T> fromJsonString<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CachedData.fromJson(json, fromJsonT);
  }

  String toJsonString(Map<String, dynamic> Function(T) toJsonT) {
    return jsonEncode(toJson(toJsonT));
  }
}
