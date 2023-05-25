import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool inMonth() {
    final now = DateTime.now();
    return now.month == this.month && now.year == this.year;
  }

  //Todo delete
  /*bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }*/

  String dateFormatter() {
    initializeDateFormatting('de_DE', null);
    //var formatter = DateFormat("HH:mm'Uhr' dd-MM-yy");
    var formatter = DateFormat("dd-MM-yy");
    return formatter.format(this);
  }
}
