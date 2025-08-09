import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';
import 'package:intl/intl.dart';

import '../../../domain/utils/date_time_reader.dart';
import '../../../get_it_model.dart';
import '../../config/app_config.dart';

class MovieDetailsController {
  final Txt _txt;
  final AppConfig _appConfig;
  final DateTimeReader _dateTimeReader;
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

  MovieDetailsController()
      : _txt = getit<Txt>(),
        _appConfig = getit<AppConfig>(),
        _dateTimeReader = getit<DateTimeReader>();

  String formatDollarAmount(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _dollarFormatter.format(amount);
  }

  String recommendOrNo(String budgeString, String revenueString) {
    var isSunday = _dateTimeReader.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var profitThreshold = int.parse(_appConfig.param(AppConfig.recommendationProfitThreshold));
    var isProfitSatisfactory = (revenue - budget) > profitThreshold;

    return isSunday && isProfitSatisfactory ? _txt.get.yes : _txt.get.no;
  }
}
