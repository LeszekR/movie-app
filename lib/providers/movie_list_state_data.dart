import '../models/movie_list.dart';

class MovieListStateData {
  final MovieList movieList;
  final double? lastScrollOffset;
  final int? selectedMovieId;

  MovieListStateData({
    required this.movieList,
    required this.lastScrollOffset,
    this.selectedMovieId,
  });

  MovieListStateData copyWith({
    MovieList? movieList,
    double? lastScrollOffset,
    int? selectedMovieId,
  }) {
    return MovieListStateData(
      movieList: movieList ?? this.movieList,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
    );
  }
}
