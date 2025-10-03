import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_style.dart';

import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/pages/movie_details/utils/movie_details_utils.dart';
import 'package:flutter_demo/app/pages/movie_details/view/components/movie_details_content_line.dart';

class MovieDetailsView extends StatelessWidget {
  final Txt _txt;
  final String title;
  final String budget;
  final String revenue;

  MovieDetailsView(
    this.title,
    this.budget,
    this.revenue, {
    super.key,
  }) : _txt = getIt<Txt>();

  @override
  Widget build(BuildContext context) {
    var controller = getIt<MovieDetailsUtils>();
    var details = makeMovieDetailsContentLine(controller, budget, revenue);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.appBarBackground,
        automaticallyImplyLeading: true,
      ),
      body: ListView.separated(
        separatorBuilder: AppStyle.movieDetailsSeparator,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(16.0),
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
      MovieDetailsUtils controller, String budget, String revenue) {
    var budgetInDollars = controller.formatDollarAmount(budget);
    var revenueInDollars = controller.formatDollarAmount(revenue);
    var recommendOrNo = controller.recommendOrNo(budget, revenue);
    return [
      MovieDetailsContentLine(label: _txt.get.budget, content: budgetInDollars),
      MovieDetailsContentLine(label: _txt.get.revenue, content: revenueInDollars),
      MovieDetailsContentLine(label: _txt.get.should_i_watch_today, content: recommendOrNo),
    ];
  }
}
