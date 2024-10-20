import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  double roundToTwoDecimal() {
    return double.parse((this).toStringAsFixed(2));
  }
}

extension CurrencyFormatting on double {
  String toCurrency({String locale = 'en_IN', String symbol = '₹'}) {
    final formatCurrency =
        NumberFormat.currency(locale: locale, symbol: symbol);
    return formatCurrency.format(this);
  }
}
