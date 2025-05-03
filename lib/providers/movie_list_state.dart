import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/movie_list.dart';
import 'movie_list_state_data.dart';

part 'movie_list_state.g.dart';

@Riverpod(keepAlive: true)
class MovieListState extends _$MovieListState {
  @override
  MovieListStateData build() {
    return MovieListStateData(
      movieList: MovieList(totalResults: 0, results: []),
      lastScrollOffset: null,
      selectedMovieId: null,
    );
  }

  MovieList getMovieList() => state.movieList;

  void setMovieList(MovieList newList) {
    state = state.copyWith(movieList: newList);
  }

  double? getScrollOffset() => state.lastScrollOffset;

  void setScrollOffset(double offset) {
    state = state.copyWith(lastScrollOffset: offset);
  }

  int? getSelectedMovieId() => state.selectedMovieId;

  void setSelectedMovieId(int? movieId) {
    state = state.copyWith(selectedMovieId: movieId);
  }
}
