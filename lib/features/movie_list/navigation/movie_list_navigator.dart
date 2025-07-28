import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../navigation/feature_navigator.dart';
import '../../movie_details/model/movie.dart';
import '../../movie_details/view/movie_details_view.dart';

class MovieListNavigator extends FeatureNavigator {
  final MovieDetailsController _movieDetailsController;

  MovieListNavigator(super.appNavigator, this._movieDetailsController);

  @override
  void onNullCommand(BuildContext context) {
    appNavigator.popProgress(context);
  }

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is ProgressNav) {
      appNavigator.showProgress(context);
    } else {
      appNavigator.popProgress(context);
      if (navCommand is NavMovieDetails) {
        _showMovieDetails(context, navCommand.payload!);
      } else if (navCommand is NavTwoButtons) {
        appNavigator.twoButtons(context);
      } else if (navCommand is ErrorDialogNav) {
        appNavigator.dialogError(context, navCommand.payload!);
      } else if (navCommand is MessageDialogNav) {
        appNavigator.dialogMessage(context, navCommand.payload!);
      }
    }
  }

  void _showMovieDetails(BuildContext context, Movie movie) {
    Navigator.push(
        context,
        MaterialPageRoute<MovieDetailsView>(
          builder: (BuildContext context) =>
              MovieDetailsView(movie.title, movie.budget.toString(), movie.revenue.toString(), _movieDetailsController),
        ));
  }
}
