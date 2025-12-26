class AppException implements Exception {
  final String message;
  final String? userMessage;
  final dynamic originalError;

  AppException({required this.message, this.userMessage, this.originalError});

  @override
  String toString() => userMessage ?? message;
}
