import 'package:flutter/material.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';

import '../movie_details/view/movie_details_view.dart';
import 'bloc/movie_list_state.dart';

class MovieListNavigator {
  final AppNavigator _appNavigator;
  const MovieListNavigator(this._appNavigator);


  void nav(MovieListState state, BuildContext context) {
    if (state.isLoading) {
      _appNavigator.progressIndicator(context);
    } else {
      Navigator.of(context).pop();
      if (state.movie != null) {
        _showMovieDetails(state, context);
      } else if (state.error != null) {
        _appNavigator.dialogError(context, state.error!);
      }
    }
  }

  void _showMovieDetails(MovieListState state, BuildContext context) {
    var movie = state.movie!;
    Navigator.push(
        context,
        MaterialPageRoute<MovieDetailsView>(
          builder: (BuildContext context) => MovieDetailsView(
            movie.title,
            movie.budget.toString(),
            movie.revenue.toString(),
          ),
        ));
  }
}