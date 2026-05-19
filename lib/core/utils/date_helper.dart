import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatLastSeen(DateTime? lastSeenAt) {
  if (lastSeenAt == null) return '';

  final now = DateTime.now();
  final difference = now.difference(lastSeenAt);

  // for within the last 24 hours, show the exact time.
  if (difference.inHours < 24) {
    return 'last seen at ${DateFormat('HH:mm').format(lastSeenAt)}';
  }
  // for more than 3 months ago example: "long time ago".
  else if (difference.inDays > 90) {
    return 'last seen a long time ago';
  }
  // For anything between 24 hours and 3 months, use the relative time formatting.
  else {
    // example: "3 months ago"
    return 'last seen ${timeago.format(lastSeenAt)}';
  }
}
