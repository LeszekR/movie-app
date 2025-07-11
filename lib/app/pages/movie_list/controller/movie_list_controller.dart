import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/app/pages/movie_list/controller/state/movie_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/data_movies_repository.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../components/scroll_controller.dart';
import '../../../components/search_box/search_text_controller.dart';
import '../../../utils/sorting/e_sort_direction.dart';
import '../../../utils/sorting/sort_criteria.dart';
import '../../../utils/sorting/sorter.dart';

part 'movie_list_controller.g.dart';

@riverpod
MovieListController movieListController(Ref ref) {
  // TODO refactor to flutter_clean_architecture

  return MovieListController(
    state: ref.read(movieListStateProvider.notifier),
    apiService: ref.read(dataMoviesRepositoryProvider),
    sorter: ref.read(createSortableSorterProvider<Movie>()),
    scrollController: ref.read(movieListScrollControllerProvider),
    searchController: ref.read(searchBoxTextControllerProvider),
  );
}

class MovieListController extends Controller {
  final MovieListState? state;
  final DataMoviesRepository apiService;
  final Sorter<Movie> sorter;
  final ScrollController scrollController;
  final TextEditingController searchController;

  MovieListController({
    required this.state,
    required this.apiService,
    required this.sorter,
    required this.scrollController,
    required this.searchController,
  });

  @override
  void initListeners() {
    // TODO implement TU PRZERWAŁEM
  }

   final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Future<List<Movie>?> fetchMovieList(String query) {
    return apiService.getSearchedMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    sorter.sortColumns(movies, _sortCriteriaList);
    state!.setMovieList(MovieList(totalResults: movies.length, results: movies));
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return apiService.getMovie(movieId);
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
