import 'package:flutter_demo/app/components/three_state_value.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../../domain/services/sorting/e_sort_direction.dart';
import '../../../../domain/services/sorting/sort_criteria.dart';
import '../../../navigation/navigation_command.dart';

final class MovieListState {
  MovieList? movieList;
  ThreeStateInt selectedMovieId;
  double scrollOffset;
  String? searchQuery;
  List<SortCriteria>? sortCriteriaList;
  NavigationCommand? navCommand;
  bool restoreView;

  static const defaultSortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  MovieListState({
    this.movieList,
    this.selectedMovieId = const ThreeStateInt.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
    this.restoreView = false,
  });

  void update({
    MovieList? movieList,
    ThreeStateInt? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
    bool? restoreView,
  }) {
    this.movieList = movieList ?? this.movieList;
    this.selectedMovieId = selectedMovieId ?? this.selectedMovieId;
    this.scrollOffset = scrollOffset ?? this.scrollOffset;
    this.searchQuery = searchQuery ?? this.searchQuery;
    this.sortCriteriaList = sortCriteriaList ?? this.sortCriteriaList;
    this.navCommand = navCommand ?? this.navCommand;
    this.restoreView = restoreView ?? (navCommand != null || this.restoreView);
  }
}
