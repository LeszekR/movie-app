import 'package:equatable/equatable.dart';

import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/three_state_value.dart';
import '../../../navigation/navigation_command.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final ThreeStateInt selectedMovieId;
  final double scrollOffset;
  final String? searchQuery;
  final List<SortCriteria>? sortCriteriaList;
  final NavigationCommand? navCommand;
  final bool restoreView;

  static const defaultSortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  const MovieListState({
    this.movieList,
    this.selectedMovieId = const ThreeStateInt.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
    this.restoreView = false,
  });

  MovieListState copyWith({
    MovieList? movieList,
    ThreeStateInt? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
    bool? restoreView,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      searchQuery: searchQuery ?? this.searchQuery,
      sortCriteriaList: sortCriteriaList ?? this.sortCriteriaList,
      navCommand: navCommand,
      restoreView:  restoreView ?? false,
    );
  }

  @override
  List<Object?> get props => [
        movieList,
        selectedMovieId,
        scrollOffset,
        searchQuery,
        sortCriteriaList,
        navCommand,
        restoreView,
      ];
}
