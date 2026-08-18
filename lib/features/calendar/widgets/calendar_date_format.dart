/// Small, dependency-free date/time formatters for the Calendar feature.
///
/// The app doesn't pull in `intl`, so these cover the two shapes the calendar
/// needs: a full day header ("Wednesday, August 12, 2026") and a 12-hour clock
/// time ("3:00 AM").
library;

const List<String> _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "Wednesday, August 12, 2026". [date] is treated as a local date.
String formatDayHeader(DateTime date) {
  final weekday = _weekdays[date.weekday - 1];
  final month = _months[date.month - 1];
  return '$weekday, $month ${date.day}, ${date.year}';
}

/// "3:00 AM" — 12-hour clock with zero-padded minutes.
String formatClockTime(DateTime date) {
  final isPm = date.hour >= 12;
  var hour = date.hour % 12;
  if (hour == 0) hour = 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${isPm ? 'PM' : 'AM'}';
}

/// A relative label for a day header when it's near today, else null.
/// Lets the UI show "Today"/"Tomorrow"/"Yesterday" prefixes.
String? relativeDayLabel(DateTime day, DateTime today) {
  final d = DateTime(day.year, day.month, day.day);
  final t = DateTime(today.year, today.month, today.day);
  final diff = d.difference(t).inDays;
  return switch (diff) {
    0 => 'Today',
    1 => 'Tomorrow',
    -1 => 'Yesterday',
    _ => null,
  };
}
