import 'package:intl/intl.dart';

String formatDateWithOrdinal(DateTime date) {
  // Get the day and add the ordinal suffix (st, nd, rd, th)
  String day = date.day.toString();
  String suffix = 'th';

  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  }

  // Format the month and year
  String formattedDate = DateFormat("MMMM yyyy").format(date);

  // Combine everything to get the desired format
  return '$day$suffix $formattedDate';
}
