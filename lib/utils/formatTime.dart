import 'package:intl/intl.dart';

String formatTime(String timestamp) {
  DateTime date = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.isAtSameMomentAs(today)) {
    return 'Today ${DateFormat('h:mm a').format(date)}';
  } else if (date.isAtSameMomentAs(yesterday)) {
    return 'Yesterday ${DateFormat('h:mm a').format(date)}';
  } else {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }
}
