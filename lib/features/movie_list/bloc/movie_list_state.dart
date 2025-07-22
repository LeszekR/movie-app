import 'package:equatable/equatable.dart';

import '../model/movie_list.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final double? scrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;
  final bool isLoading;
  final bool showMoviesNotFoundDialog;
  final Exception? error;

  const MovieListState({
    this.movieList,
    this.scrollOffset,
    this.selectedMovieId,
    this.searchQuery,
    this.isLoading = false,
    this.showMoviesNotFoundDialog = false,
    this.error,
  });

  MovieListState copyWith({
    MovieList? movieList,
    double? scrollOffset,
    int? selectedMovieId,
    String? searchQuery,
    bool isLoading = false,
    Exception? error,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? false,
      showMoviesNotFoundDialog: _foundQueriedMovies(movieList),
      error: error,
    );
  }

  bool _foundQueriedMovies(MovieList? movieList) {
    if (!isLoading) return false;
    return movieList != null &&   // on start MovieList is null - we do not show dialog then
        movieList.totalResults == 0;
  }

  @override
  List<Object?> get props =>
      [movieList, scrollOffset, selectedMovieId, searchQuery, isLoading, showMoviesNotFoundDialog, error];
}
