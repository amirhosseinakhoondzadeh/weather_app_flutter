import 'package:intl/intl.dart';

class DateTimeConverter {
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getDayOfWeekAbbreviation(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static DateTime fromUnixTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  }
}
