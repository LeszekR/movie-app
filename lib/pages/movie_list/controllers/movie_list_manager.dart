// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/search_text_controller.dart';
import 'package:flutter_recruitment_task/pages/movie_list/state/movie_list_state.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/movie.dart';
import '../../../models/movie_list.dart';
import '../../../services/api_service.dart';
import '../../../utils/sorting/sort_criteria.dart';
import '../../../utils/sorting/e_sort_direction.dart';
import '../../../utils/sorting/sorter.dart';

part 'movie_list_manager.g.dart';

@riverpod
MovieListManager movieListManager(Ref ref) {
  return MovieListManager(
    state: ref.read(movieListStateProvider.notifier),
    apiService: ref.read(apiServiceProvider),
    sorter: ref.read(createSortableSorterProvider<Movie>()),
    scrollController: ref.read(movieListScrollControllerProvider),
    searchController: ref.read(searchBoxTextControllerProvider),
  );
}

class MovieListManager {
  final MovieListState? state;
  final ApiService apiService;
  final Sorter<Movie> sorter;
  final ScrollController scrollController;
  final TextEditingController searchController;

  MovieListManager({
    required this.state,
    required this.apiService,
    required this.sorter,
    required this.scrollController,
    required this.searchController,
  });

   final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Future<List<Movie>?> fetchMovieList(String query) {
    return apiService.searchMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    sorter.sortColumns(movies, _sortCriteriaList);
    state!.setMovieList(MovieList(totalResults: movies.length, results: movies));
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return apiService.movie(movieId);
  }

  void restoreScroll() {
    double? lastScrollOffset = state!.getScrollOffset();
    if (lastScrollOffset == null) return;
    scrollController.jumpTo(lastScrollOffset);
  }

  void restoreSearchQuery() {
    searchController.text = state!.getSearchQuery() ?? '';
  }
}
