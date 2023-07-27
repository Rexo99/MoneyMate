import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Class for DateTime extensions.
/// Code by Erik Hinkelmanns
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  /// Returns true if the date is in the current month.
  /// Code by Erik Hinkelmanns
  bool inMonth() {
    final now = DateTime.now();
    return now.month == this.month && now.year == this.year;
  }

  /// return DateTime as formatted string for displaying
  /// Code by Erik Hinkelmanns
  String dateFormatter() {
    initializeDateFormatting('de_DE', null);
    //var formatter = DateFormat("HH:mm'Uhr' dd-MM-yy");
    var formatter = DateFormat("dd-MM-yy");
    return formatter.format(this);
  }
}
