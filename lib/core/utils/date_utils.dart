import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateUtils {
  static int getChecksum(List<int> data, int count) {
    int sum = 0;
    try {
      for (int i = 0; i < count; i++) {
        sum += data[i];
      }
    } catch (error) {
      print(error);
// Do nothing
    }
    return sum & 0xFF;
  }

  //https://api.flutter.dev/flutter/intl/DateFormat-class.html
  static String getStringFromDate(int dateTime){
    var format;
    if(dateTime==null){
      return "";
    }
      format = DateFormat('dd/MM/yyyy');

    var dateOut = new DateTime.fromMillisecondsSinceEpoch(dateTime);
    return format.format(dateOut);
  }
  static String getStringFromDateTime(int dateTime ){
    if(dateTime==null){
      return "";
    }
    var format = DateFormat('HH:mm');
    var dateOut = new DateTime.fromMillisecondsSinceEpoch(dateTime);
    return format.format(dateOut);
  }

  static String convertStringFromDate({int dateTime, String pattern} ){
    initializeDateFormatting();
    var format;
    if(dateTime==null){
      return "";
    }
    if(pattern!=null){
      format = DateFormat(pattern, "fr_FR");
    }else{
      format = DateFormat('dd/MM/yyyy', "fr_FR");
    }
    //return "";
    var dateOut = new DateTime.fromMillisecondsSinceEpoch(dateTime);
    return format.format(dateOut);
  }


}
