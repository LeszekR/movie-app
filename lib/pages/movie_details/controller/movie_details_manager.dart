import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_recruitment_task/utils/date_time_reader.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_details_manager.g.dart';

@riverpod
class MovieDetailsManager extends _$MovieDetailsManager {
  final _dollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);
  final int _interestingProfits = 1000000;

  @override
  void build() {}

  String formatDollarAmount(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _dollarFormatter.format(amount);
  }

  String recommendOrNo(String budgeString, String revenueString) {
    var isSunday = ref.read(dateTimeReaderProvider).now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var isProfitSatisfactory = (revenue - budget) > _interestingProfits;

    return isSunday && isProfitSatisfactory ? Txt.get.yes : Txt.get.no;
  }
}
