import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';

import '../../../get_it_model.dart';
import '../../movie_details/model/movie.dart';
import '../../movie_details/view/movie_details_view.dart';
import '../bloc/movie_list_state.dart';

class MovieListNavigator {
  final AppNavigator _appNavigator;

  const MovieListNavigator(this._appNavigator);

  void go(MovieListState state, BuildContext context) {
    if (state.navCommand is ShowLoading) {
      _appNavigator.progress(context);
    } else {
      _appNavigator.popIfPossible(context);

      if (state.navCommand is ShowMovieDetails) {
        _showMovieDetails(state, context);
      } else if (state.navCommand is ShowError) {
        _appNavigator.dialogError(context, state.navCommand!.payload);
      }
    }
  }

  void _showMovieDetails(MovieListState state, BuildContext context) {
    Movie movie = state.navCommand!.payload;
    Navigator.push(
        context,
        MaterialPageRoute<MovieDetailsView>(
          builder: (BuildContext context) => MovieDetailsView(
            movie.title,
            movie.budget.toString(),
            movie.revenue.toString(),
            getit<MovieDetailsController>()
          ),
        ));
  }
}
