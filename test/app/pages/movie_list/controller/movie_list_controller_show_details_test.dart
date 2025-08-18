import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_tools/controller_test/controller_test_runner.dart';
import '../../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../../test_tools/test_utils.dart';
import 'movie_list_controller_test_data.dart';

void main() {
  MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
  MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    initGetIt();
    getItReplaceFactory<DataMovieRepository>(() => mockDataMovieRepository);
  });

  setUp(() {
    when(mockDataMovieRepository.getMovie(d.movieId_A2))
        .thenAnswer((_) => Future.value(d.movieList_A.results[d.movieId_A2]));
    when(mockDataMovieRepository.getMovie(d.movieId_B3))
        .thenAnswer((_) => Future.value(d.movieList_B.results[d.movieId_B3]));
    when(mockDataMovieRepository.getMovie(d.movieId_ErrHttp)).thenThrow(d.errMovieHttp);
    when(mockDataMovieRepository.getMovie(d.movieId_ErrOther)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockDataMovieRepository);
  });

  controllerTest(
    'show movie details => show progress',
    build: () => MovieListController(),
    seed: () => MovieListState(
      movieList: d.movieList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_A2),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      restoreView: true,
    ),
    act: (controller) => controller.fetchMovie(),
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavProgressOn(),
        restoreView: true,
      ),
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
        restoreView: true,
      )
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieId_A2)).called(1);
    },
  );

  controllerTest(
    'show movie details => none selected',
    build: () => MovieListController(),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: ThreeStateInt.none(),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_B,
      navCommand: null,
      restoreView: false,
    ),
    act: (controller) => controller.fetchMovie(),
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: ThreeStateInt.none(),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
        restoreView: true,
      ),
    ],
    verify: () {
      verifyNever(mockDataMovieRepository.getMovie(any));
    },
  );

  controllerTest(
    'show movie details => http error',
    build: () => MovieListController(),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavErrorDialog(d.errMovieHttp),
      ),
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieId_ErrHttp)).called(1);
    },
  );

  controllerTest(
    'show movie details => other error',
    build: () => MovieListController(),
    seed: () => MovieListState(
      movieList: d.movieList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: null,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavErrorDialog(d.errRepoOther),
      ),
    ],

    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieId_ErrOther)).called(1);
    },
  );

  controllerTest(
    'show movie details => success',
    build: () => MovieListController(),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: ThreeStateInt.value(d.movieId_B3),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: ThreeStateInt.value(d.movieId_B3),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavMovieDetails(d.movieList_B.results[d.movieId_B3]),
      ),
    ],

    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieId_B3)).called(1);
    },
  );
}
