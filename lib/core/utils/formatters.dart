import 'package:intl/intl.dart';

final _time = DateFormat('h:mm a');
final _day = DateFormat('EEE, d MMM');
final _dayWithYear = DateFormat('d MMM yyyy');
final _dateTime = DateFormat('d MMM yyyy, h:mm a');

String formatTime(DateTime at) => _time.format(at);

String formatDateTime(DateTime at) => _dateTime.format(at);

/// First and last name initials: "Olalekan Israel Efunkunle" -> "OE".
String initials(String name) {
  final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  final first = parts.first[0];
  return (parts.length == 1 ? first : '$first${parts.last[0]}').toUpperCase();
}

/// "Today", "Yesterday", "Mon, 14 Sep", or with the year if not this year.
String formatDayLabel(DateTime at, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  final day = _dateOnly(at);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return day.year == today.year ? _day.format(at) : _dayWithYear.format(at);
}

String greeting({DateTime? now}) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
