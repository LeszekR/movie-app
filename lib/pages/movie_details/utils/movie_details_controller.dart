import 'package:intl/intl.dart';

import '../../../bootstrap/app_params.dart';
import '../../../common/utils/date_time_reader.dart';

class MovieDetailsController {
  final AppParams appParams;
  final DateTimeReader dateTimeReader;
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

  MovieDetailsController(this.dateTimeReader, this.appParams);

  String formatDollarAmount(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _dollarFormatter.format(amount);
  }

  bool recommendOrNo(String budgeString, String revenueString) {
    var isSunday = dateTimeReader.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var profitThreshold = int.parse(appParams.param(AppParams.recommendationProfitThreshold));
    var isProfitSatisfactory = (revenue - budget) > profitThreshold;

    return isSunday && isProfitSatisfactory;
  }
}
