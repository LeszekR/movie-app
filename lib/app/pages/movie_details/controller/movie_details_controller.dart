// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:flutter_recruitment_task/domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/config/app_config.dart';
import '../../../../domain/utils/date_time_reader/date_time_reader.dart';


part 'movie_details_controller_provider.g.dart';

@riverpod
MovieDetailsController movieDetailsController(Ref ref) => MovieDetailsController(
      ref.read(dateTimeReaderProvider),
      ref.read(appConfigProvider),
    );

class MovieDetailsController {
  // TODO refactor to flutter_clean_architecture
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
