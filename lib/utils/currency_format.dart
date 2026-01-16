import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

String formatRupiah(int number) {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormatter.format(number);
}