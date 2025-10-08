import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/pages/movie_details/model/movie.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/pages/movie_list/model/movie_list.dart';
import 'package:flutter_demo/pages/movie_list/view/components/movie_card_data.dart';
import 'package:flutter_demo/repositories/movie_repository_exception.dart';

import '../../../test_tools/mocks/common_mocks.mocks.dart';


class MovieListTestData {
  MovieListBloc makeMovieListBloc(MockAppParams mockAppParams, MockMovieRepository mockMovieRepository) =>
      MovieListBloc(mockAppParams, mockMovieRepository, Sorter<Movie>());

  String queryA = 'QUERY_A';
  String queryB = 'QUERY_B';
  String queryNotFound = 'QUERY_NOT_FOUND';
  String queryHttpErr = 'QUERY_HTTP_ERR';
  String queryOtherErr = 'QUERY_OTHER_ERR';

  int movieIdA2 = 2;
  int movieIdB3 = 3;
  int movieIdErrHttp = 22;
  int movieIdErrOther = 33;

  int selectedId3 = 3;
  int selectedId18 = 18;

  double scrollOffset8 = 8;
  double scrollOffset230 = 230;

  MovieListHttpException errSearchHttp = MovieListHttpException(404);
  MovieDetailsHttpException errMovieHttp = MovieDetailsHttpException(404);
  Exception errRepoOther = Exception('other exception');

  MovieList movieListA = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        const Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        const Movie(id: 1, budget: 111, revenue: 811, voteAverage: 1.2, title: 'TestMovie 1'),
        const Movie(id: 2, budget: 122, revenue: 822, voteAverage: 2.2, title: 'TestMovie 2'),
        const Movie(id: 3, budget: 133, revenue: 833, voteAverage: 3.2, title: 'TestMovie 3'),
      ], MovieListState.defaultSortCriteriaList,)!,);

  MovieList movieListB = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        const Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        const Movie(id: 4, budget: 144, revenue: 844, voteAverage: 4.2, title: 'TestMovie 4'),
        const Movie(id: 5, budget: 155, revenue: 855, voteAverage: 5.2, title: 'TestMovie 5'),
        const Movie(id: 6, budget: 166, revenue: 866, voteAverage: 6.2, title: 'TestMovie 6'),
      ], MovieListState.defaultSortCriteriaList,)!,);

  List<MovieCardData> movieCardDataListA = [];
  List<MovieCardData> movieCardDataListB = [];

  Future<void> init(MockAppParams mockAppParams, MockMovieRepository mockMovieRepository) async {
    final movieListBloc = makeMovieListBloc(mockAppParams, mockMovieRepository);
    movieCardDataListA = await movieListBloc.makeMovieCardDataList(movieListA.results);
    movieCardDataListB = await movieListBloc.makeMovieCardDataList(movieListB.results);
  }
}
