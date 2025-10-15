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
  final MockMovieListNavigator mockMovieListNavigator = MockMovieListNavigator();
  final MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    getIt.registerLazySingleton(MovieListState.new);
    await d.init();
  });

  setUp(() {
    when(mockDataMovieRepository.getSearchedMovies(d.queryNotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockDataMovieRepository.getSearchedMovies(d.queryA)).thenAnswer((_) => Future.value(d.movieListA.results));
    when(mockDataMovieRepository.getSearchedMovies(d.queryB)).thenAnswer((_) => Future.value(d.movieListB.results));
    when(mockDataMovieRepository.getSearchedMovies(d.queryHttpErr)).thenThrow(d.errSearchHttp);
    when(mockDataMovieRepository.getSearchedMovies(d.queryOtherErr)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockDataMovieRepository);
    reset(mockMovieListNavigator);
  });

  group('search movies - progress indicator', () {
    controllerTest(
      'search show progress',
      seed: MovieListState.new,
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryA),
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          searchQuery: d.queryA,
          navCommand: NavProgressOn(),
        ),
        MovieListState(
          movieCardDataList: d.movieCardDataListA,
          searchQuery: d.queryA,
          navCommand: NavProgressOff(),
        ),
      ],
    );
  });

  group('search movies - edge cases', () {
    controllerTest(
      'search query empty string',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(''),
      seed: MovieListState.new,
      expect: () => [MovieListState()],
      verify: () {
        verifyNever(mockDataMovieRepository.getSearchedMovies(any));
      },
    );
  });

  group('empty list => search movies => failed', () {
    controllerTest(
      'empty => search not found',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryNotFound),
      seed: MovieListState.new,
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryNotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryNotFound)).called(1);
      },
    );

    controllerTest(
      'empty  => search http error',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryHttpErr),
      seed: MovieListState.new,
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryHttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryHttpErr)).called(1);
      },
    );

    controllerTest(
      'empty  => search other error',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryOtherErr),
      seed: MovieListState.new,
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryOtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryOtherErr)).called(1);
      },
    );
  });

  group('full list => search movies => failed', () {
    controllerTest(
      'full => search not found',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryNotFound),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListB,
        searchQuery: d.queryB,
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryNotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryNotFound)).called(1);
      },
    );

    controllerTest(
      'full => search http error',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryHttpErr),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.selectedId18),
        searchQuery: d.queryB,
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryHttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryHttpErr)).called(1);
      },
    );

    controllerTest(
      'full => search other error',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryOtherErr),
      seed: () => MovieListState(
        movieCardDataList: List.empty(),
        searchQuery: d.queryA,
        navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryOtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryOtherErr)).called(1);
      },
    );
  });

  // SEARCH SUCCESSFUL
  group('search movies => successful', () {
    controllerTest(
      'empty list => search => successful A',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryA),
      seed: MovieListState.new,
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataListA,
          searchQuery: d.queryA,
          navCommand: NavProgressOff(),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryA)).called(1);
      },
    );

    controllerTest(
      'full list => search => successful B',
      build: () => makeMovieListController(mockDataMovieRepository),
      act: (controller) => controller.fetchSearchedMovies(d.queryB),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataListB,
          searchQuery: d.queryB,
          navCommand: NavProgressOff(),
        ),
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.queryB)).called(1);
      },
    );
  });
}
