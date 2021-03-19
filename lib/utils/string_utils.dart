import 'package:intl/intl.dart';

/// This method turns the given number into a string in the american format

String format(dynamic number) {
  return number is num && number >= 0 ? NumberFormat.currency(
      locale: "en_US",
      symbol: "",
      decimalDigits: 0
  ).format(number) : "?";
}