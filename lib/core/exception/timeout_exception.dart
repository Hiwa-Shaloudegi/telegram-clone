class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Operation timed out']);

  @override
  String toString() => message;
}
