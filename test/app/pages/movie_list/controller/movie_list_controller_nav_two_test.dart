import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_tools/controller_test/controller_test.dart';
import '../../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../../test_tools/test_utils.dart';
import 'movie_list_controller_test_data.dart';

void main() {
  MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
  MovieListTestData d = MovieListTestData();

  setUpAll(() {
    initGetIt();
    unregisterSafely<DataMovieRepository>();
    getIt.registerFactory(() => mockDataMovieRepository);
    unregisterSafely<GetSearchedMoviesUseCase>();
    getIt.registerFactory(() => GetSearchedMoviesUseCase(mockDataMovieRepository));
    unregisterSafely<GetMovieDetailsUseCase>();
    getIt.registerFactory(() => GetMovieDetailsUseCase(mockDataMovieRepository));
  });

  controllerTest(
    'show two buttons view',
    seed: () => MovieListState(
      movieList: d.movieList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_A2),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_A,
      navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
      restoreView: false,
    ),
    build: () => MovieListController(),
    act: (controller) => controller.navTwoButtons(d.query_A, d.scrollOffset_230),
    expect: () => [
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavTwoButtons(),
        restoreView: true,
      ),
    ],
    verify: () {
      verifyNever(mockDataMovieRepository.getSearchedMovies(any));
      verifyNever(mockDataMovieRepository.getMovie(any));
    },
  );
}
