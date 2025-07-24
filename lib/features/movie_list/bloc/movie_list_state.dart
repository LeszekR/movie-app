import 'package:equatable/equatable.dart';

import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';

final class MovieListState extends Equatable {
  final MovieList? movieList;
  final double? scrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;
  final bool isLoading;
  final bool showNoMoviesFoundDialog;
  final Movie? movie;
  final Exception? error;

  const MovieListState({
    this.movieList,
    this.scrollOffset,
    this.selectedMovieId,
    this.searchQuery,
    this.isLoading = false,
    this.showNoMoviesFoundDialog = false,
    this.movie,
    this.error,
  });

  MovieListState copyWith({
    MovieList? movieList,
    double? scrollOffset = 0,
    int? selectedMovieId,
    String? searchQuery,
    bool isLoading = false,
    Movie? movie,
    Exception? error,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading,
      showNoMoviesFoundDialog: _foundQueriedMovies(movieList),
      movie: movie,
      error: error,
    );
  }

  bool _foundQueriedMovies(MovieList? movieList) {
    if (!isLoading) return false;
    return movieList != null && // on start MovieList is null - we do not show dialog then
        movieList.totalResults == 0;
  }

  @override
  List<Object?> get props =>
      [movieList, scrollOffset, selectedMovieId, searchQuery, isLoading, showNoMoviesFoundDialog, movie, error];
}
