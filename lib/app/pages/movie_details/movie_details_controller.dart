import 'package:flutter_recruitment_task/domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'package:intl/intl.dart';

import '../../../data/app_config.dart';
import '../../../domain/utils/date_time_reader.dart';

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

  String recommendOrNo(String budgeString, String revenueString) {
    var isSunday = dateTimeReader.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var profitThreshold = int.parse(appConfig.param(AppConfig.recommendationProfitThreshold));
    var isProfitSatisfactory = (revenue - budget) > profitThreshold;

    return isSunday && isProfitSatisfactory ? Txt.get.yes : Txt.get.no;
  }
}
