import 'package:flutter/material.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/navigation/feature_navigator.dart';
import 'package:flutter_demo/app/navigation/go_router_const_strings.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';

class MovieListNavigator extends FeatureNavigator {
  const MovieListNavigator(super.appNavigator);

  @override
  void navigate(BuildContext context, NavigationCommand<dynamic> navCommand) {
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
    context.pushNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: movie.title,
        paramMovieBudget: movie.budget.toString(),
        paramMovieRevenue: movie.revenue.toString(),
      },
    );
  }
}
