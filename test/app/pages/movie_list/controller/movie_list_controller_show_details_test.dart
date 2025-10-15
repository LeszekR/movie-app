import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_tools/controller_test/controller_test_runner.dart';
import '../../../../test_tools/controller_test/utils.dart';
import '../../../../test_tools/mocks/common_mocks.mocks.dart';
import 'movie_list_controller_test_data.dart';

void main() {
  final MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
  final MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    getIt.registerLazySingleton(MovieListState.new);
    await d.init();
  });

  setUp(() {
    when(mockDataMovieRepository.getMovie(d.movieIdA2))
        .thenAnswer((_) => Future.value(d.movieListA.results[d.movieIdA2]));
    when(mockDataMovieRepository.getMovie(d.movieIdB3))
        .thenAnswer((_) => Future.value(d.movieListB.results[d.movieIdB3]));
    when(mockDataMovieRepository.getMovie(d.movieIdErrHttp)).thenThrow(d.errMovieHttp);
    when(mockDataMovieRepository.getMovie(d.movieIdErrOther)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockDataMovieRepository);
  });

  controllerTest(
    'show movie details => show progress',
    build: () => makeMovieListController(mockDataMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdA2),
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryA,
      navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
    ),
    act: (controller) => controller.fetchMovie(),
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavProgressOn(),
      ),
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
      ),
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieIdA2)).called(1);
    },
  );

  controllerTest(
    'show movie details => none selected',
    build: () => makeMovieListController(mockDataMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryB,
    ),
    act: (controller) => controller.fetchMovie(),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryB,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ),
    ],
    verify: () {
      verifyNever(mockDataMovieRepository.getMovie(any));
    },
  );

  controllerTest(
    'show movie details => http error',
    build: () => makeMovieListController(mockDataMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      selectedMovieId: ThreeStateInt.value(d.movieIdErrHttp),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryB,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.movieIdErrHttp),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryB,
        navCommand: NavErrorDialog(d.errMovieHttp),
      ),
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieIdErrHttp)).called(1);
    },
  );

  controllerTest(
    'show movie details => other error',
    build: () => makeMovieListController(mockDataMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdErrOther),
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryA,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdErrOther),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavErrorDialog(d.errRepoOther),
      ),
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieIdErrOther)).called(1);
    },
  );

  controllerTest(
    'show movie details => success',
    build: () => makeMovieListController(mockDataMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      selectedMovieId: ThreeStateInt.value(d.movieIdB3),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryB,
    ),
    act: (controller) => controller.fetchMovie(),
    skip: 1,
    asyncTicks: 1,
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.movieIdB3),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryB,
        navCommand: NavMovieDetails(d.movieListB.results[d.movieIdB3]),
      ),
    ],
    verify: () {
      verify(mockDataMovieRepository.getMovie(d.movieIdB3)).called(1);
    },
  );
}
