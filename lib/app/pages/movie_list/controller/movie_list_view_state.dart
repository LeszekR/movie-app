
import '../../../../domain/entities/movie_list.dart';

class MovieListViewState {
  // TODO refactor to flutter_clean_architecture
  final MovieList movieList;
  final double? lastScrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;

  MovieListViewState({
    required this.movieList,
    this.lastScrollOffset,
    this.selectedMovieId,
    this.searchQuery,
  });

  MovieListViewState copyWith({
    MovieList? movieList,
    double? lastScrollOffset,
    int? selectedMovieId,
    String? searchQuery,
  }) {
    return MovieListViewState(
      movieList: movieList ?? this.movieList,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
