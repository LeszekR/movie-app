import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../get_it_model.dart';
import '../../../navigation/feature_navigator.dart';
import '../../movie_details/model/movie.dart';
import '../../movie_details/view/movie_details_view.dart';

class MovieListNavigator extends FeatureNavigator {
  MovieListNavigator(super.appNavigator);

  @override
  void onNullCommand(BuildContext context) {
    appNavigator.popProgress(context);
  }

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is ShowLoading) {
      appNavigator.showProgress(context);
    } else {
      appNavigator.popProgress(context);
      if (navCommand is ShowMovieDetails) {
        _showMovieDetails(navCommand, context);
      } else if (navCommand is ShowError) {
        appNavigator.dialogError(context, navCommand.payload!);
      } else if (navCommand is ShowMessage) {
        appNavigator.dialogMessage(context, navCommand.payload!);
      }
    }
  }

  void _showMovieDetails(NavigationCommand navCommand, BuildContext context) {
    Movie movie = navCommand.payload;
    Navigator.push(
        context,
        MaterialPageRoute<MovieDetailsView>(
          builder: (BuildContext context) => MovieDetailsView(
              movie.title, movie.budget.toString(), movie.revenue.toString(), getit<MovieDetailsController>()),
        ));
  }
}
