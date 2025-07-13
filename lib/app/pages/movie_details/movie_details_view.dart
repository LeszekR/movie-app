import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'components/movie_details_content_line.dart';
import 'controller/movie_details_controller.dart';

// TODO use get_it
class MovieDetailsView extends ConsumerWidget {
  final String title;
  final String budget;
  final String revenue;

  const MovieDetailsView(
    this.title,
    this.budget,
    this.revenue, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.read(movieDetailsControllerProvider);
    var details = makeMovieDetailsContentLine(controller, budget, revenue);

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

  List<MovieDetailsContentLine> makeMovieDetailsContentLine(
      MovieDetailsController controller, String budget, String revenue) {
    var budgetInDollars = controller.formatDollarAmount(budget);
    var revenueInDollars = controller.formatDollarAmount(revenue);
    var recommendOrNo = controller.recommendOrNo(budget, revenue);
    return [
      MovieDetailsContentLine(label: Txt.get.budget, content: budgetInDollars),
      MovieDetailsContentLine(label: Txt.get.revenue, content: revenueInDollars),
      MovieDetailsContentLine(label: Txt.get.should_i_watch_today, content: recommendOrNo),
    ];
  }
}
