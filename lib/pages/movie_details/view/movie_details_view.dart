import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_colors.dart';
import 'package:flutter_demo/common/config/app_style.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/pages/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/pages/movie_details/view/components/movie_details_content_line.dart';

class MovieDetailsView extends StatelessWidget {
  final Txt txt;
  final String title;
  final String budget;
  final String revenue;
  final MovieDetailsController controller;

  const MovieDetailsView(
    this.txt,
    this.title,
    this.budget,
    this.revenue,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final details = _makeMovieDetailsContentLine(controller, budget, revenue);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.appBarBackground,
      ),
      body: ListView.separated(
        separatorBuilder: AppStyle.movieDetailsSeparator,
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

  List<MovieDetailsContentLine> _makeMovieDetailsContentLine(
      MovieDetailsController controller, String budget, String revenue,) {
    final budgetInDollars = controller.formatDollarAmount(budget);
    final revenueInDollars = controller.formatDollarAmount(revenue);
    final recommendOrNo = controller.recommendOrNo(budget, revenue) ? txt.get.yes : txt.get.no;
    return [
      MovieDetailsContentLine(label: txt.get.budget, content: budgetInDollars),
      MovieDetailsContentLine(label: txt.get.revenue, content: revenueInDollars),
      MovieDetailsContentLine(label: txt.get.should_i_watch_today, content: recommendOrNo),
    ];
  }
}
