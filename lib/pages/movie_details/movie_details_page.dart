import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';

// TODO - why stateful? refactor to stateless?
class MovieDetailsPage extends StatefulWidget {
  final String budget;
  final String revenue;

  const MovieDetailsPage(this.budget, this.revenue, {super.key});

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  List<MovieDetails> _details = [];

  @override
  void initState() {
    super.initState();
    _details = [
      MovieDetails(title: 'Budget', content: '\$${widget.budget}'),
      MovieDetails(title: 'Revenue', content: '\$${widget.revenue}'),
      MovieDetails(title: 'Should I watch it today?', content: _getIsWorthwhile()),
    ];
  }

  String _getIsWorthwhile() {
    var revenue = int.parse(widget.revenue);
    var budget = int.parse(widget.budget);
    // TODO replace arbitrary criteria 1000000 with dynamic one
    return (revenue - budget) > 1000000 ? 'Yes!' : 'No...';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
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
                  _details[index].title,
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
