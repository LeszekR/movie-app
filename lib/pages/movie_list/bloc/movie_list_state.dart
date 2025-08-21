import 'package:equatable/equatable.dart';

import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/three_state_value.dart';
import '../../../navigation/navigation_command.dart';
import '../../movie_details/model/movie.dart';
import '../view/components/movie_card_data.dart';

final class MovieListState extends Equatable {
  final List<MovieCardData>? movieCardDataList;
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
    this.movieCardDataList,
    this.selectedMovieId = const ThreeStateInt.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
    this.restoreView = false,
  });

  MovieListState copyWith({
    List<MovieCardData>? movieCardDataList,
    ThreeStateInt? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
    bool? restoreView,
  }) {
    return MovieListState(
      movieCardDataList: movieCardDataList ?? this.movieCardDataList,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      searchQuery: searchQuery ?? this.searchQuery,
      sortCriteriaList: sortCriteriaList ?? this.sortCriteriaList,
      navCommand: navCommand,
      restoreView: restoreView ?? false,
    );
  }

  @override
  List<Object?> get props => [
        movieCardDataList,
        selectedMovieId,
        scrollOffset,
        searchQuery,
        sortCriteriaList,
        navCommand,
        restoreView,
      ];
}
