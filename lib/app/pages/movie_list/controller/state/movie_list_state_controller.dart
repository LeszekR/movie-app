import 'package:riverpod_annotation/riverbed_annotation.dart';

import '../../../../../domain/entities/movie_list.dart';
import '../movie_list_view_state.dart';

// @Riverpod(keepAlive: true)
// class MovieListStateController extends _$MovieListStateController {
class MovieListStateController {
  // @override
  // MovieListViewState build() {
  //   return MovieListViewState(
  //     movieList: MovieList(totalResults: 0, results: []),
  //   );
  // }
  var state = MovieListViewState(movieList: MovieList(totalResults: 0, results: []));

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

  String? getSearchQuery() => state.searchQuery;

  void setSearchQuery(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
  }
}
