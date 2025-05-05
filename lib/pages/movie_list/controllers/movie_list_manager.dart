// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/search_text_controller.dart';
import 'package:flutter_recruitment_task/pages/movie_list/state/movie_list_state.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/scroll_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/movie.dart';
import '../../../models/movie_list.dart';
import '../../../services/api_service.dart';
import '../../../utils/sorting/sort_criteria.dart';
import '../../../utils/sorting/e_sort_direction.dart';
import '../../../utils/sorting/sorter.dart';

part 'movie_list_manager.g.dart';

@riverpod
class MovieListManager extends _$MovieListManager {
   MovieListState? _state;
   ApiService? _apiService;
   Sorter<Movie>? _sorter;
   ScrollController? _scrollController;
   TextEditingController? _searchController;

   final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  @override
  MovieListManager build() {
    _state = ref.read(movieListStateProvider.notifier);
    _apiService = ref.read(apiServiceProvider);
    _sorter = ref.read(createSortableSorterProvider<Movie>());
    _scrollController = ref.read(movieListScrollControllerProvider);
    _searchController = ref.read(searchBoxTextControllerProvider);

    return this;
  }

  Future<List<Movie>?> fetchMovieList(String query) {
    return _apiService!.searchMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    _sorter!.sortColumns(movies, _sortCriteriaList);
    _state!.setMovieList(MovieList(totalResults: movies.length, results: movies));
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return _apiService!.movie(movieId);
  }

  void restoreScroll() {
    double? lastScrollOffset = _state!.getScrollOffset();
    if (lastScrollOffset == null) return;
    _scrollController!.jumpTo(lastScrollOffset);
  }

  void restoreSearchQuery() {
    _searchController!.text = _state!.getSearchQuery() ?? '';
  }
}
