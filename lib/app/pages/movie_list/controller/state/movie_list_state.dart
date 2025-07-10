

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/movie_list.dart';
import '../movie_list_view_state.dart';

part 'movie_list_state_provider.g.dart';

@Riverpod(keepAlive: true)
class MovieListState extends _$MovieListState {
  @override
  MovieListViewState build() {
    return MovieListViewState(
      movieList: MovieList(totalResults: 0, results: []),
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

  String? getSearchQuery() => state.searchQuery;

  void setSearchQuery(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
  }
}
