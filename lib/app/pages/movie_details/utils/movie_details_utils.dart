import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:intl/intl.dart';

class MovieDetailsUtils {
  final AppParams _appParams;
  final DateTimeReader _dateTimeReader;
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

  MovieDetailsUtils(this._appParams, this._dateTimeReader);

  String formatDollarAmount(String amountString) {
    final amount = int.parse(amountString);
    if (amount <= 0) return r'$ 0';
    return _dollarFormatter.format(amount);
  }

  bool recommendOrNo(String budgeString, String revenueString) {
    final isSunday = _dateTimeReader.now().weekday == 7;

    final revenue = int.parse(revenueString);
    final budget = int.parse(budgeString);
    final profitThreshold = int.parse(_appParams.param(AppParams.recommendationProfitThreshold));
    final isProfitSatisfactory = (revenue - budget) > profitThreshold;

    return isSunday && isProfitSatisfactory;
  }
}
