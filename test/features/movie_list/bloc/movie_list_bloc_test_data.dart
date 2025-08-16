import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/model/movie_list.dart';
import 'package:flutter_demo/repositories/movie_repository_exception.dart';

import '../../../mocks/common_mocks.mocks.dart';


class MovieListTestData {
  MovieListBloc makeMovieListBloc(MockMovieRepository mockMovieRepository) =>
      MovieListBloc(mockMovieRepository, Sorter<Movie>());

  String query_A = 'QUERY_A';
  String query_B = 'QUERY_B';
  String query_NotFound = 'QUERY_NOT_FOUND';
  String query_HttpErr = 'QUERY_HTTP_ERR';
  String query_OtherErr = 'QUERY_OTHER_ERR';

  int movieId_A2 = 2;
  int movieId_B3 = 3;
  int movieId_ErrHttp = 22;
  int movieId_ErrOther = 33;

  int selectedId_3 = 3;
  int selectedId_18 = 18;

  double scrollOffset_8 = 8;
  double scrollOffset_230 = 230;

  var errSearchHttp = MovieListHttpException(404);
  var errMovieHttp = MovieDetailsHttpException(404);
  var errRepoOther = Exception('other exception');

  MovieList movieList_A = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        Movie(id: 1, budget: 111, revenue: 811, voteAverage: 1.2, title: 'TestMovie 1'),
        Movie(id: 2, budget: 122, revenue: 822, voteAverage: 2.2, title: 'TestMovie 2'),
        Movie(id: 3, budget: 133, revenue: 833, voteAverage: 3.2, title: 'TestMovie 3'),
      ], MovieListState.defaultSortCriteriaList)!);

  MovieList movieList_B = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        Movie(id: 4, budget: 144, revenue: 844, voteAverage: 4.2, title: 'TestMovie 4'),
        Movie(id: 5, budget: 155, revenue: 855, voteAverage: 5.2, title: 'TestMovie 5'),
        Movie(id: 6, budget: 166, revenue: 866, voteAverage: 6.2, title: 'TestMovie 6'),
      ], MovieListState.defaultSortCriteriaList)!);
}
