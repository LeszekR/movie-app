import 'package:equatable/equatable.dart';

import '../model/movie_list.dart';
import '../../../navigation/nav_commands_common.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final MovieId selectedMovieId;
  final double? scrollOffset;
  final String? searchQuery;
  final NavigationCommand? navCommand;

  const MovieListState({
    this.movieList,
    this.selectedMovieId = const MovieId.none(),
    this.scrollOffset,
    this.searchQuery,
    this.navCommand,
  });

  MovieListState copyWith({
    MovieList? movieList,
    MovieId? selectedMovieId,
    double? scrollOffset = 0,
    String? searchQuery,
    NavigationCommand? navCommand,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      searchQuery: searchQuery ?? this.searchQuery,
      navCommand: navCommand,
    );
  }

  @override
  List<Object?> get props => [movieList, selectedMovieId, scrollOffset, searchQuery, navCommand];
}

class MovieId {
  final bool hasValue;
  final int? id;

  const MovieId.none()
      : hasValue = false,
        id = null;

  const MovieId.value(int this.id) : hasValue = true;
}
