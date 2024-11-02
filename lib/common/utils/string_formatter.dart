class StringFormatter {
  static String getTimePassedString(DateTime? date, {DateTime? now}) {
    if (date == null) {
      return "Unknown";
    }
    now = now ?? DateTime.now();
    Duration difference = now.difference(date);
    if (difference.isNegative) {
      return "0s ago";
    }
    int days = difference.inDays;
    if (days >= 365) {
      return "${(days / 365).floor()}Y ago";
    }
    if (days >= 30) {
      return "${(days / 30).floor()}M ago";
    }
    if (days >= 7) {
      return "${(days / 7).floor()}W ago";
    }
    if (days > 0) {
      return "${days}D ago";
    }
    if (difference.inHours != 0) {
      return "${difference.inHours}h ago";
    }
    if (difference.inMinutes != 0) {
      return "${difference.inMinutes}m ago";
    }
    if (difference.inSeconds != 0) {
      return "${difference.inSeconds}s ago";
    }
    return "";
  }
}
