import 'package:flutter_recruitment_task/models/movie_list.dart';

class MovieListView {
  final MovieList movieList;
  final double? lastScrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;

  MovieListView({
    required this.movieList,
    this.lastScrollOffset,
    this.selectedMovieId,
    this.searchQuery,
  });

  MovieListView copyWith({
    MovieList? movieList,
    double? lastScrollOffset,
    int? selectedMovieId,
    String? searchQuery,
  }) {
    return MovieListView(
      movieList: movieList ?? this.movieList,
      lastScrollOffset: lastScrollOffset ?? this.lastScrollOffset,
      selectedMovieId: selectedMovieId ?? this.selectedMovieId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
