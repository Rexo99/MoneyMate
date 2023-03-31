import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String dateFormatter(DateTime dateTime) {
  initializeDateFormatting('de_DE', null);
  //var formatter = DateFormat("HH:mm'Uhr' dd-MM-yy");
  var formatter = DateFormat("dd-MM-yy");
  return formatter.format(dateTime);
}