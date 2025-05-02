import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_store.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
import '../../models/movie_list.dart';
import '../../services/api_service.dart';
import '../../utils/routing/go_router_const_strings.dart';
import '../../utils/sorting/column_sort_criteria.dart';
import '../../utils/sorting/e_sort_direction.dart';
import '../../utils/sorting/sortable_sorter.dart';

class MovieListController {
  ApiService? apiService;

  // TODO - DI
  MovieListController(this.apiService);

  final SortableSorter<Movie> _movieSorter = SortableSorter();
  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Future<List<Movie>?> fetchMovieList(String query) {
    return apiService!.searchMovies(query);
  }

  void updateMovieList(MovieListStore movieListContent, List<Movie> movies) {
    _movieSorter.sortColumns(movies, sortCriteriaList: _sortCriteriaList);
    movieListContent.updateMovieList(MovieList(totalResults: movies.length, results: movies));
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return apiService!.movie(movieId);
  }

  void openMovieDetails(BuildContext context, Movie? fetchedMovie, int movieId) {
    if (fetchedMovie == null) {
      return;
    }
    context.goNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: fetchedMovie.title.toString(),
        paramMovieBudget: fetchedMovie.budget.toString(),
        paramMovieRevenue: fetchedMovie.revenue.toString(),
      },
    );
  }

  void restoreScroll(MovieListStore movieListStore, ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollController.jumpTo(movieListStore.lastScrollOffset));
  }
}
