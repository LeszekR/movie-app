import 'package:intl/intl.dart';

import '../../../../domain/ui_localized_texts/txt.dart';
import '../../../../domain/utils/date_time_reader.dart';
import '../../../../get_it_model.dart';
import '../../../config/app_config.dart';

class MovieDetailsUtils {
  final Txt _txt;
  final AppConfig _appConfig;
  final DateTimeReader _dateTimeReader;
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

  MovieDetailsUtils()
      : _txt = getIt<Txt>(),
        _appConfig = getIt<AppConfig>(),
        _dateTimeReader = getIt<DateTimeReader>();

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
