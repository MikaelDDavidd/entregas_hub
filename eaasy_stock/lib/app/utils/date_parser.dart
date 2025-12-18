import 'package:intl/intl.dart';

class DateParser {
  static DateTime? parse(String dateString) {
    List<DateFormat> formats = [
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('dd/MM/yyyy HH:mm'),
      DateFormat('dd/MM/yyyy HH:mm:ss'),
      DateFormat('yyyy-MM-dd HH:mm'),
    ];

    for (var format in formats) {
      try {
        return format.parse(dateString);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static String formatDate(String dateString) {
    DateTime? date = parse(dateString);
    if (date == null) return "N/A";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(String dateString) {
    DateTime? date = parse(dateString);
    if (date == null) return "N/A";
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(String dateString) {
    DateTime? date = parse(dateString);
    if (date == null) return "N/A";
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }
}
