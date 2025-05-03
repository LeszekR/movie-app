import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/providers/movie_list_scroll.dart';
import 'package:flutter_recruitment_task/providers/movie_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/movie.dart';
import '../../models/movie_list.dart';
import '../../services/api_service.dart';
import '../../utils/sorting/sort_criteria.dart';
import '../../utils/sorting/e_sort_direction.dart';
import '../../utils/sorting/sorter.dart';

part 'movie_list_manager.g.dart';

@riverpod
class MovieListManager extends _$MovieListManager {
  ApiService? _apiService;
  Sorter<Movie>? _movieSorter;
  MovieListState? _movieListState;
  ScrollController? _listScrollController;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  @override
  MovieListManager build() {
    _apiService = ref.read(apiServiceProvider);
    _movieSorter = ref.read(createSortableSorterProvider<Movie>());
    _movieListState = ref.read(movieListStateProvider.notifier);
    _listScrollController = ref.read(movieListScrollControllerProvider);

    return MovieListManager();
  }

  Future<List<Movie>?> fetchMovieList(String query) {
    return _apiService!.searchMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    _movieSorter!.sortColumns(movies, sortCriteriaList: _sortCriteriaList);
    _movieListState!.setMovieList(MovieList(totalResults: movies.length, results: movies));
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return _apiService!.movie(movieId);
  }

  void restoreScroll() {
    double? lastScrollOffset = _movieListState!.getScrollOffset();
    if (lastScrollOffset == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _listScrollController!.jumpTo(lastScrollOffset);
    });
  }
}
