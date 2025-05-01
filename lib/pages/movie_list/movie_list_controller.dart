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

  var selectedMovieBudget_DUMMY = '5000000';
  var selectedMovieRevenue_DUMMY = '8000000';

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

  GestureTapCallback? openMovieDetails(BuildContext context) {
    return () {
      context.goNamed(
        routeMovieDetails,
        pathParameters: {paramMovieBudget: selectedMovieBudget_DUMMY, paramMovieRevenue: selectedMovieRevenue_DUMMY},
      );
    };
  }
}
