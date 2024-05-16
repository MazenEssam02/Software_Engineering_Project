import 'package:intl/intl.dart';
import 'dart:io';

class CurrencyHelper {
  static String getSymbol() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencySymbol;
  }

  static String? getSymbolName() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName;
  }
}
