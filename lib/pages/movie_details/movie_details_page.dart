import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:intl/intl.dart';

import '../../utils/now_inject.dart';


class MovieDetailsPage extends StatefulWidget {

  // TODO refactor? MovieDetailsPage to StatelessWidget?

  final NowInject nowInject;
  final String title;
  final String budget;
  final String revenue;

  const MovieDetailsPage(
    this.nowInject,
    this.title,
    this.budget,
    this.revenue, {
    super.key,
  });

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  String _title = "";
  List<MovieDetails> _details = [];
  var _amountDollarFormatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);
  int _interestingProfits = 1000000;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _details = [
      MovieDetails(label: 'Budget', content: _makeDollarAmountString(widget.budget)),
      MovieDetails(label: 'Revenue', content: _makeDollarAmountString(widget.revenue)),
      MovieDetails(label: 'Should I watch it today?', content: _getIsWorthwhile()),
    ];
  }

  String _makeDollarAmountString(String amountString) {
    var amount = int.parse(amountString);
    if (amount <= 0) return '\$ 0';
    return _amountDollarFormatter.format(amount);
  }

  String _getIsWorthwhile() {
    var isSunday = widget.nowInject.weekday() == 7;

    var revenue = int.parse(widget.revenue);
    var budget = int.parse(widget.budget);
    var isProfitSatisfactory = (revenue - budget) > _interestingProfits;

    return isSunday && isProfitSatisfactory ? 'Yes!' : 'No...';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.amberAccent.shade400,
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Container(
            height: 1.0,
            color: Colors.grey.shade300,
          ),
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _details[index].label,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8.0),
                Text(
                  _details[index].content,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          itemCount: _details.length,
        ),
      );
}
