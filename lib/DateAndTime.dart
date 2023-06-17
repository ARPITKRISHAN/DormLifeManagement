import 'package:intl/intl.dart';

class DateAndTime {

  static String convertedDateAndTime(String? str){

    String inputString = (str != null ? str : "2023-06-08T23:21:00.000000Z");

    DateTime dateTime = DateTime.parse(inputString);

    String formattedDateTime = DateFormat('MMMM d, yyyy h:mm a').format(dateTime);

    return formattedDateTime; // Output: June 8, 2023 11:21 PM
  }

}