import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:intl/intl.dart';

// TODO refactor? MovieDetailsPage to StatelessWidget?

class MovieDetailsPage extends StatefulWidget {
  final String title;
  final String budget;
  final String revenue;

  const MovieDetailsPage(
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
  int _interestingProfits = 1000000;
  var formatter = NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 0);

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

    // debug only
    // amount += (Random().nextDouble() * 3000000 + 2000000).round();
    return formatter.format(amount);
  }

  String _getIsWorthwhile() {
    var revenue = int.parse(widget.revenue);
    var budget = int.parse(widget.budget);
    return (revenue - budget) > _interestingProfits ? 'Yes!' : 'No...';
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
