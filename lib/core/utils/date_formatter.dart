// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String dayMonthYear(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String monthDayYear(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String dateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }
}
