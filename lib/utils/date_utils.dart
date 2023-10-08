import 'package:intl/intl.dart';

extension TimeExtension on DateTime {
  String toTimeOfDay() => DateFormat('HH:mm').format(this);

  String toDateOfYear() {
    var dateFormat = 'd MMMM';
    if (year != DateTime.now().year) dateFormat += ', yyyy';
    return DateFormat(dateFormat).format(this);
  }

  String toLastOnlineTime() {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 2) {
      return 'online ${difference.inMinutes} minute ago';
    } else if (difference.inMinutes < 60) {
      return 'online ${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 2) {
      return 'online ${difference.inHours} hour ago';
    } else if (difference.inHours < 6 && now.day == day) {
      return 'online ${difference.inHours} hours ago';
    } else if (difference.inHours < 24 && now.day == day) {
      return 'online today at ${DateFormat('HH:mm').format(this)}';
    } else if (difference.inHours < 24 && now.day - day == 1) {
      return 'online yesterday at ${DateFormat('HH:mm').format(this)}';
    } else if (difference.inDays < 2) {
      return 'online ${difference.inDays} day ago';
    } else if (difference.inDays < 7) {
      return 'online on ${DateFormat('EEEE').format(this)} at ${DateFormat('HH:mm').format(this)}';
    } else if (difference.inDays >= 7 && difference.inDays < 31) {
      return 'online on ${DateFormat('d MMMM').format(this)} at ${DateFormat('HH:mm').format(this)}';
    } else {
      return 'offline for a long time';
    }
  }

  bool equalsDay(DateTime date) => day == date.day;
}
