import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
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

  Future<List<Movie>> onSearchBoxSubmitted(String query) {
    if (query.isNotEmpty) {
      return apiService!.searchMovies(query).then((movies) {
        _movieSorter.sortColumns(movies, sortCriteriaList: _sortCriteriaList);
        return Future.value(movies);
      });
    } else {
      return Future.value([]);
    }
  }

  Future<Movie?> fetchMovie(int movieId) async {
    return apiService!.movie(movieId);
  }

  void openMovieDetails(BuildContext context, Movie? fetchedMovie, int movieId) {
    if (fetchedMovie == null) {
      print("Failed to fetch movie with id: $movieId");
      return;
    }
    print("Found movie with id: $movieId");
    context.goNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieBudget: fetchedMovie.budget.toString(),
        paramMovieRevenue: fetchedMovie.revenue.toString(),
      },
    );
  }
}
