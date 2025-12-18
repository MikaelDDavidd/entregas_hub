import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Data não disponível';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return 'Há ${minutes}min';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Há ${hours}h';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Há ${days}d';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  static String formatDateTimeFull(DateTime? dateTime) {
    if (dateTime == null) return 'Data não disponível';
    return DateFormat('dd/MM/yyyy \'às\' HH:mm').format(dateTime);
  }

  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Data não disponível';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Hora não disponível';
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatRelative(DateTime? dateTime) {
    if (dateTime == null) return 'Data não disponível';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) {
      return 'Hoje às ${formatTime(dateTime)}';
    } else if (dateToCheck == yesterday) {
      return 'Ontem às ${formatTime(dateTime)}';
    } else {
      return formatDateTimeFull(dateTime);
    }
  }
}
