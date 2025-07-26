import 'package:equatable/equatable.dart';

import '../model/movie_list.dart';
import '../../../navigation/nav_commands_common.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final double? scrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;
  final NavigationCommand? navCommand;

  const MovieListState({
    this.movieList,
    this.scrollOffset,
    this.selectedMovieId,
    this.searchQuery,
    this.navCommand,
  });

  MovieListState copyWith({
    MovieList? movieList,
    double? scrollOffset = 0,
    int? selectedMovieId,
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
  List<Object?> get props =>
      [movieList, scrollOffset, selectedMovieId, searchQuery, navCommand];
}
