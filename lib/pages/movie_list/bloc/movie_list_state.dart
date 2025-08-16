import 'package:equatable/equatable.dart';

import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../navigation/navigation_command.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final MovieId selectedMovieId;
  final double scrollOffset;
  final String? searchQuery;
  final List<SortCriteria>? sortCriteriaList;
  final NavigationCommand? navCommand;

  static const defaultSortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  const MovieListState({
    this.movieList,
    this.selectedMovieId = const MovieId.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
  });

  MovieListState copyWith({
    MovieList? movieList,
    MovieId? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      searchQuery: searchQuery ?? this.searchQuery,
      sortCriteriaList: sortCriteriaList ?? this.sortCriteriaList,
      navCommand: navCommand,
    );
  }

  @override
  List<Object?> get props => [movieList, selectedMovieId, scrollOffset, searchQuery, sortCriteriaList, navCommand];
}

class MovieId extends Equatable {
  final bool hasValue;
  final int? id;

  const MovieId.none()
      : hasValue = false,
        id = null;

  const MovieId.value(int this.id) : hasValue = true;

  @override
  List<Object?> get props => [hasValue, id];
}
