part of 'movie_list_state.dart';

final class MovieListEmptyState extends MovieListState {}

final class MovieListLoadedState extends MovieListState {
  final MovieList? movieList;
  final double? scrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;

  const MovieListLoadedState(this.movieList, this.scrollOffset, this.selectedMovieId, this.searchQuery);

  MovieListLoadedState copyWith({
    MovieList? movieList,
    double? scrollOffset,
    int? selectedMovieId,
    String? searchQuery,
  }) {
    return MovieListLoadedState(
      movieList = movieList ?? this.movieList,
      scrollOffset = scrollOffset ?? this.scrollOffset,
      selectedMovieId = selectedMovieId ?? this.selectedMovieId,
      searchQuery = searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [movieList, scrollOffset, selectedMovieId, searchQuery];
}

final class MovieListSearchErrorState extends MovieListState {
  final Exception e;
  const MovieListSearchErrorState(this.e);
}
