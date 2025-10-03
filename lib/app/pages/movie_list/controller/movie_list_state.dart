import 'package:flutter_demo/app/components/three_state_value.dart';

import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/services/sorting/e_sort_direction.dart';
import 'package:flutter_demo/domain/services/sorting/sort_criteria.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card_data.dart';

final class MovieListState {
  List<MovieCardData>? movieCardDataList;
  ThreeStateInt selectedMovieId;
  double scrollOffset;
  String? searchQuery;
  List<SortCriteria>? sortCriteriaList;
  NavigationCommand? navCommand;

  static const defaultSortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  MovieListState({
    this.movieCardDataList,
    this.selectedMovieId = const ThreeStateInt.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
  });

  void update({
    List<MovieCardData>? movieCardDataList,
    ThreeStateInt? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
  }) {
    this.movieCardDataList = movieCardDataList ?? this.movieCardDataList;
    this.selectedMovieId = selectedMovieId ?? this.selectedMovieId;
    this.scrollOffset = scrollOffset ?? this.scrollOffset;
    this.searchQuery = searchQuery ?? this.searchQuery;
    this.sortCriteriaList = sortCriteriaList ?? this.sortCriteriaList;
    this.navCommand = navCommand;
  }
}
