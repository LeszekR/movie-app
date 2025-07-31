import 'package:flutter/material.dart';

import '../../../common/ui_localized_texts/txt.dart';
import '../utils/movie_details_controller.dart';
import 'components/movie_details_content_line.dart';

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
    var details = _makeMovieDetailsContentLine(controller, budget, revenue);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.amberAccent.shade400,
        automaticallyImplyLeading: true,
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
                details[index].label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8.0),
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
      MovieDetailsController controller, String budget, String revenue) {
    var budgetInDollars = controller.formatDollarAmount(budget);
    var revenueInDollars = controller.formatDollarAmount(revenue);
    var recommendOrNo = controller.recommendOrNo(budget, revenue) ? txt.get.yes : txt.get.no;
    return [
      MovieDetailsContentLine(label: txt.get.budget, content: budgetInDollars),
      MovieDetailsContentLine(label: txt.get.revenue, content: revenueInDollars),
      MovieDetailsContentLine(label: txt.get.should_i_watch_today, content: recommendOrNo),
    ];
  }
}
