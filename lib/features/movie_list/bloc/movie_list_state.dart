import 'package:equatable/equatable.dart';

import '../model/movie_list.dart';
import '../../../navigation/nav_commands_common.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final double? scrollOffset;
  final MovieId selectedMovieId;
  final String? searchQuery;
  final NavigationCommand? navCommand;

  const MovieListState({
    this.movieList,
    this.scrollOffset,
    this.selectedMovieId = const MovieId.none(),
    this.searchQuery,
    this.navCommand,
  });

  MovieListState copyWith({
    MovieList? movieList,
    double? scrollOffset = 0,
    MovieId? selectedMovieId,
    String? searchQuery,
    NavigationCommand? navCommand,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      searchQuery: searchQuery ?? this.searchQuery,
      navCommand: navCommand,
    );
  }

  @override
  List<Object?> get props => [movieList, scrollOffset, selectedMovieId, searchQuery, navCommand];
}

class MovieId {
  final bool hasValue;
  final int? id;

  const MovieId.none(): hasValue = false, id = null;

  const MovieId.of(int this.id) : hasValue = true;
}
