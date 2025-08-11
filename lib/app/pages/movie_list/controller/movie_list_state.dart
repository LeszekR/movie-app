import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../navigation/navigation_command.dart';

final class MovieListState {
  MovieList? movieList;
  MovieId selectedMovieId;
  double scrollOffset;
  String? searchQuery;
  List<SortCriteria>? sortCriteriaList;
  NavigationCommand? navCommand;
  NavigationCommand? prevNavCommand;

  static const defaultSortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  MovieListState({
    this.movieList,
    this.selectedMovieId = const MovieId.none(),
    this.scrollOffset = 0,
    this.searchQuery,
    this.sortCriteriaList = defaultSortCriteriaList,
    this.navCommand,
    this.prevNavCommand,
  });

  void update({
    MovieList? movieList,
    MovieId? selectedMovieId,
    double? scrollOffset,
    String? searchQuery,
    List<SortCriteria>? sortCriteriaList,
    NavigationCommand? navCommand,
  }) {
    this.movieList = movieList ?? this.movieList;
    this.selectedMovieId = selectedMovieId ?? this.selectedMovieId;
    this.scrollOffset = scrollOffset ?? this.scrollOffset;
    this.searchQuery = searchQuery ?? this.searchQuery;
    this.sortCriteriaList = sortCriteriaList ?? this.sortCriteriaList;
    prevNavCommand = this.navCommand;
    this.navCommand = navCommand;
  }

// MovieListState copyWith({
//   MovieList? movieList,
//   MovieId? selectedMovieId,
//   double? scrollOffset,
//   String? searchQuery,
//   List<SortCriteria>? sortCriteriaList,
//   NavigationCommand? navCommand,
// }) {
//   var prevNavCommand = this.navCommand;
//   return MovieListState(
//     movieList: movieList ?? this.movieList,
//     selectedMovieId: selectedMovieId ?? this.selectedMovieId,
//     scrollOffset: scrollOffset ?? this.scrollOffset,
//     searchQuery: searchQuery ?? this.searchQuery,
//     sortCriteriaList: sortCriteriaList ?? this.sortCriteriaList,
//     navCommand: navCommand,
//     prevNavCommand: prevNavCommand,
//   );
// }

// @override
// List<Object?> get props => [movieList, selectedMovieId, scrollOffset, searchQuery, sortCriteriaList, navCommand];
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
