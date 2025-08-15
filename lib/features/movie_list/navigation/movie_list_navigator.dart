import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';

import '../../../common/ui_localized_texts/txt.dart';
import '../../../navigation/feature_navigator.dart';
import '../../../navigation/navigation_command.dart';
import '../../movie_details/model/movie.dart';
import '../../movie_details/view/movie_details_view.dart';

class MovieListNavigator extends FeatureNavigator {
  final Txt txt;
  final MovieDetailsController _movieDetailsController;

  MovieListNavigator(this.txt, this._movieDetailsController);

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is NavMovieDetails) {
      _showMovieDetails(context, navCommand.payload!);
    } else if (navCommand is NavTwoButtons) {
      appNavigator.twoButtons(context);
    } else if (navCommand is NavMessageDialog) {
      appNavigator.dialogMessage(context, navCommand.payload!);
    } else if (navCommand is NavErrorDialog) {
      appNavigator.dialogError(context, navCommand.payload!);
    } else {
      appNavigator.throwOnMissingNav(navCommand);
    }
  }

  void _showMovieDetails(BuildContext context, Movie movie) {
    Navigator.push(
        context,
        MaterialPageRoute<MovieDetailsView>(
          builder: (BuildContext context) => MovieDetailsView(
            txt,
            movie.title,
            movie.budget.toString(),
            movie.revenue.toString(),
            _movieDetailsController,
          ),
        ));
  }
}
