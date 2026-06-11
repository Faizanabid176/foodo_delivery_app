// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static String format(num amount, {String symbol = 'PKR '}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: 0)
        .format(amount);
  }

  static String compact(num amount, {String symbol = 'PKR '}) {
    return NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 1)
        .format(amount);
  }
}
