class PendingDmExtra {
  final String otherUserId;
  final String displayName;
  final String? profileImageUrl;
  final bool isOnline;
  final DateTime? lastSeenAt;

  PendingDmExtra({
    required this.otherUserId,
    required this.displayName,
    this.profileImageUrl,
    this.isOnline = false,
    this.lastSeenAt,
  });
}
