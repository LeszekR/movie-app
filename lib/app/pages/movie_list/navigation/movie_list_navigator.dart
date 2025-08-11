import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/movie.dart';
import '../../../navigation/feature_navigator.dart';
import '../../../navigation/go_router_const_strings.dart';
import '../../../navigation/app_nav_commands.dart';
import '../../../navigation/navigation_command.dart';
import 'nav_commands.dart';

class MovieListNavigator extends FeatureNavigator {

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is NavProgress) {
      appNavigator.showProgress(context);
    } else {
      appNavigator.popProgress(context);
      if (navCommand is NavMovieDetails) {
        _showMovieDetails(context, navCommand.payload!);
      } else if (navCommand is NavTwoButtons) {
        appNavigator.twoButtons(context);
      } else if (navCommand is NavMessageDialog) {
        appNavigator.dialogMessage(context, navCommand.payload!);
      } else if (navCommand is NavErrorDialog) {
        appNavigator.dialogError(context, navCommand.payload!);
      }
    }
  }

  void _showMovieDetails(BuildContext context, Movie movie) {
    context.pushNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: movie.title.toString(),
        paramMovieBudget: movie.budget.toString(),
        paramMovieRevenue: movie.revenue.toString(),
      },
    );
  }
}
