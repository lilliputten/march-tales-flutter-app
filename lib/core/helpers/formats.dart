import 'package:intl/intl.dart';

String formatDate(DateTime date, String locale) {
  final format = DateFormat.yMMMMd(locale);
  return format.format(date);
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatDuration(Duration duration) {
  final items = [
    duration.inHours,
    duration.inMinutes.remainder(60).abs(),
    duration.inSeconds.remainder(60).abs(),
  ];
  final List<String> parts = [];
  bool hasNonZero = false;
  // for(final n in items) {
  for (var i = 0; i < items.length; i++) {
    final n = items[i];
    if (hasNonZero) {
      parts.add(twoDigits(n));
    } else if (i == items.length - 1) {
      // The single element: always make in form '0:XX'
      parts.add('0');
      parts.add(twoDigits(n));
    } else if (n != 0) {
      // First non-zero (but not the last) element, pass it without leading zeros
      hasNonZero = true;
      parts.add(n.toString());
    }
  }
  return parts.join(':');
}

String formatSecondsDuration(int seconds) {
  return formatDuration(Duration(seconds: seconds));
}
