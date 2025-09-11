// lib/core/utils/date_utils.dart
import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthDayYear = DateFormat('MMM dd, yyyy');
  static final DateFormat _fullDate = DateFormat('EEEE, MMMM dd, yyyy');
  static final DateFormat _time12Hour = DateFormat('hh:mm a');
  static final DateFormat _time24Hour = DateFormat('HH:mm');
  static final DateFormat _dateTime = DateFormat('MMM dd, yyyy hh:mm a');

  static String formatDate(DateTime date, {DateFormat? format}) {
    return (format ?? _dayMonthYear).format(date);
  }

  static String formatDateReadable(DateTime date) {
    return _monthDayYear.format(date);
  }

  static String formatFullDate(DateTime date) {
    return _fullDate.format(date);
  }

  static String formatTime(DateTime date, {bool use24Hour = false}) {
    return (use24Hour ? _time24Hour : _time12Hour).format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTime.format(date);
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
