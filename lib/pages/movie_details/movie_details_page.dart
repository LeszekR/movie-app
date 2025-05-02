import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_logic.dart';

class MovieDetailsPage extends StatelessWidget {
  final String title;
  final String budget;
  final String revenue;
  final List<MovieDetails> _details;
  final MovieDetailsLogic movieDetailsLogic;

  MovieDetailsPage(
    this.title,
    this.budget,
    this.revenue,
    this.movieDetailsLogic, {
    super.key,
  }) : _details = movieDetailsLogic.makeMovieDetails(budget, revenue);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
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
