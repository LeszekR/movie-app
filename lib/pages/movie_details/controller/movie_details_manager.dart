import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/date_time_reader/date_time_reader.dart';

part 'movie_details_manager.g.dart';

@riverpod
MovieDetailsManager movieDetailsManager(Ref ref) => MovieDetailsManager(ref.read(dateTimeReaderProvider));

class MovieDetailsManager {
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);
  final int _interestingProfits = 1000000;
  final DateTimeReader dateTimeReader;

  MovieDetailsManager(this.dateTimeReader);

  String formatDollarAmount(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _dollarFormatter.format(amount);
  }

  String recommendOrNo(String budgeString, String revenueString) {
    var isSunday = dateTimeReader.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var isProfitSatisfactory = (revenue - budget) > _interestingProfits;

    return isSunday && isProfitSatisfactory ? Txt.get.yes : Txt.get.no;
  }
}
