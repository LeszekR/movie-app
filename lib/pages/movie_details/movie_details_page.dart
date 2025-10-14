import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/controller/movie_details_manager.dart';
import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(movieDetailsManagerProvider);
    final details = makeMovieDetails(manager, budget, revenue);

    return Scaffold(
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                details[index].label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8.0),
              Text(
                details[index].content,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        itemCount: details.length,
      ),
    );
  }

  List<MovieDetails> makeMovieDetails(MovieDetailsManager manager, String budget, String revenue) {
    final budgetInDollars = manager.formatDollarAmount(budget);
    final revenueInDollars = manager.formatDollarAmount(revenue);
    final recommendOrNo = manager.recommendOrNo(budget, revenue);
    return [
      MovieDetails(label: Txt.get.budget, content: budgetInDollars),
      MovieDetails(label: Txt.get.revenue, content: revenueInDollars),
      MovieDetails(label: Txt.get.should_i_watch_today, content: recommendOrNo),
    ];
  }
}
