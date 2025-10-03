import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card_data.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/entities/movie_list.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository_exception.dart';
import 'package:flutter_demo/domain/services/sorting/sorter.dart';

class MovieListTestData {
  String queryA = 'QUERY_A';
  String queryB = 'QUERY_B';
  String queryNotFound = 'QUERY_NOT_FOUND';
  String queryHttpErr = 'QUERY_HTTP_ERR';
  String queryOtherErr = 'QUERY_OTHER_ERR';

  int movieIdA2 = 2;
  int movieIdB3 = 3;
  int movieIdErrHttp = 22;
  int movieIdErrOther = 33;

  int selectedId_3 = 3;
  int selectedId_18 = 18;

  double scrollOffset_8 = 8;
  double scrollOffset_230 = 230;

  MovieListHttpException errSearchHttp = MovieListHttpException(404);
  MovieDetailsHttpException errMovieHttp = MovieDetailsHttpException(404);
  MovieListOtherException errRepoOther = MovieListOtherException();

  // MovieList movieCardDataList_Empty = MovieList(totalResults: 0, results: List.empty());

  MovieList movieListA = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        Movie(id: 1, budget: 111, revenue: 811, voteAverage: 1.2, title: 'TestMovie 1'),
        Movie(id: 2, budget: 122, revenue: 822, voteAverage: 2.2, title: 'TestMovie 2'),
        Movie(id: 3, budget: 133, revenue: 833, voteAverage: 3.2, title: 'TestMovie 3'),
      ], MovieListState.defaultSortCriteriaList,)!,);

  MovieList movieListB = MovieList(
      totalResults: 4,
      results: Sorter<Movie>().sortColumns([
        Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
        Movie(id: 4, budget: 144, revenue: 844, voteAverage: 4.2, title: 'TestMovie 4'),
        Movie(id: 5, budget: 155, revenue: 855, voteAverage: 5.2, title: 'TestMovie 5'),
        Movie(id: 6, budget: 166, revenue: 866, voteAverage: 6.2, title: 'TestMovie 6'),
      ], MovieListState.defaultSortCriteriaList,)!,);

  List<MovieCardData> movieCardDataListA = [];
  List<MovieCardData> movieCardDataListB = [];

  Future<void> init() async {
    final movieListController = MovieListController();
    movieCardDataListA = await movieListController.makeMovieCardDataList(movieListA.results);
    movieCardDataListB = await movieListController.makeMovieCardDataList(movieListB.results);
  }
}
