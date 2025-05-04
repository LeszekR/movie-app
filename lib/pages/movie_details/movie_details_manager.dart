import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/utils/now_inject.dart';
import 'package:intl/intl.dart';

class MovieDetailsManager {
  final NowInject nowInject;
  final _amountDollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);
  final int _interestingProfits = 1000000;

  MovieDetailsManager(this.nowInject);

  List<MovieDetails> makeMovieDetails(String budgetString, String revenueString) => [
        MovieDetails(label: 'Budget', content: makeDollarAmountString(budgetString)),
        MovieDetails(label: 'Revenue', content: makeDollarAmountString(revenueString)),
        MovieDetails(label: 'Should I watch it today?', content: getIsWorthwhile(budgetString, revenueString)),
      ];

  String makeDollarAmountString(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _amountDollarFormatter.format(amount);
  }

  String getIsWorthwhile(String budgeString, String revenueString) {
    var isSunday = nowInject.now().weekday == 7;

    var revenue = int.parse(revenueString);
    var budget = int.parse(budgeString);
    var isProfitSatisfactory = (revenue - budget) > _interestingProfits;

    return isSunday && isProfitSatisfactory ? 'Yes!' : 'No...';
  }
}
