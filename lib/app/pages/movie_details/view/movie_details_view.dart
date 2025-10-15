import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_style.dart';
import 'package:flutter_demo/app/pages/movie_details/utils/movie_details_utils.dart';
import 'package:flutter_demo/app/pages/movie_details/view/components/movie_details_content_line.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';

class MovieDetailsView extends StatelessWidget {
  final String title;
  final String budget;
  final String revenue;
  final MovieDetailsUtils utils;

  const MovieDetailsView(
    this.title,
    this.budget,
    this.revenue,
    this.utils, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final details = makeMovieDetailsContentLine(context, utils, budget, revenue);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.appBarBackground,
      ),
      body: ListView.separated(
        separatorBuilder: movieDetailsSeparator,
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

  List<MovieDetailsContentLine> makeMovieDetailsContentLine(
    BuildContext context,
    MovieDetailsUtils controller,
    String budget,
    String revenue,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final budgetInDollars = controller.formatDollarAmount(budget);
    final revenueInDollars = controller.formatDollarAmount(revenue);
    final recommendOrNo = controller.recommendOrNo(budget, revenue);
    final content = recommendOrNo ? localizations.yes : localizations.no;
    return [
      MovieDetailsContentLine(label: localizations.budget, content: budgetInDollars),
      MovieDetailsContentLine(label: localizations.revenue, content: revenueInDollars),
      MovieDetailsContentLine(label: localizations.should_i_watch_today, content: content),
    ];
  }
}
