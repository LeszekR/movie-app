import 'package:intl/intl.dart';

import '../../../common/config/app_config.dart';
import '../../../common/utils/date_time_reader.dart';

class MovieDetailsController {
  final AppConfig appConfig;
  final DateTimeReader dateTimeReader;
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

  MovieDetailsController(this.dateTimeReader, this.appConfig);

  String formatDollarAmount(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _dollarFormatter.format(amount);
  }

  bool recommendOrNo(String budgeString, String revenueString) {
    var isSunday = dateTimeReader.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var profitThreshold = int.parse(appConfig.param(AppConfig.recommendationProfitThreshold));
    var isProfitSatisfactory = (revenue - budget) > profitThreshold;

    return isSunday && isProfitSatisfactory;
  }
}
