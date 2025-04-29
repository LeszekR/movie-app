import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({super.key});

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  final _details = [
    MovieDetails(title: 'Budget', content: '\$2400000'),
    MovieDetails(title: 'Revenue', content: '\$10000000'),
    MovieDetails(title: 'Should I watch it today?', content: 'Yes!'),
  ];

  @override
  void initState() {
    super.initState();
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
