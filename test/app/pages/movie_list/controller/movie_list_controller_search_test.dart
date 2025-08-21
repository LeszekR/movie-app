import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/services/sorting/sorter.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/sort_movies_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_tools/controller_test/controller_test_runner.dart';
import '../../../../test_tools/mocks/common_mocks.mocks.dart';
import 'movie_list_controller_test_data.dart';

void main() {
  MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
  MockMovieListNavigator mockMovieListNavigator = MockMovieListNavigator();
  MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    getIt.registerSingleton(AppParams());
    getIt.registerFactory(() => Sorter<Movie>());
    getIt.registerFactory<DataMovieRepository>(() => mockDataMovieRepository);
    getIt.registerFactory<GetSearchedMoviesUseCase>(() => GetSearchedMoviesUseCase(mockDataMovieRepository));
    getIt.registerFactory<GetMovieDetailsUseCase>(() => GetMovieDetailsUseCase(mockDataMovieRepository));
    getIt.registerFactory<SortMoviesUseCase>(() => SortMoviesUseCase(getIt<Sorter<Movie>>()));
    getIt.registerFactory<MovieListPresenter>(() => MovieListPresenter());
    getIt.registerLazySingleton(() => MovieListState());
    getIt.registerFactory<MovieListNavigator>(() => mockMovieListNavigator);
    d.init();
  });

  setUp(() {
    when(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockDataMovieRepository.getSearchedMovies(d.query_A)).thenAnswer((_) => Future.value(d.movieList_A.results));
    when(mockDataMovieRepository.getSearchedMovies(d.query_B)).thenAnswer((_) => Future.value(d.movieList_B.results));
    when(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).thenThrow(d.errSearchHttp);
    when(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockDataMovieRepository);
    reset(mockMovieListNavigator);
  });

  group('search movies - progress indicator', () {
    controllerTest(
      'search show progress',
      seed: () => MovieListState(),
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_A),
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: null,
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_A,
          navCommand: NavProgressOn(),
        ),
        MovieListState(
          movieCardDataList: d.movieCardDataList_A,
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_A,
          navCommand: NavProgressOff(),
        ),
      ],
    );
  });

  group('search movies - edge cases', () {
    controllerTest(
      'search query empty string',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(''),
      seed: () => MovieListState(),
      expect: () => [MovieListState()],
      verify: () {
        verifyNever(mockDataMovieRepository.getSearchedMovies(any));
      },
    );
  });

  group('empty list => search movies => failed', () {
    controllerTest(
      'empty => search not found',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_NotFound),
      seed: () => MovieListState(),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_NotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).called(1);
      },
    );

    controllerTest(
      'empty  => search http error',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_HttpErr),
      seed: () => MovieListState(),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_HttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).called(1);
      },
    );

    controllerTest(
      'empty  => search other error',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_OtherErr),
      seed: () => MovieListState(),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_OtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).called(1);
      },
    );
  });

  group('full list => search movies => failed', () {
    controllerTest(
      'full => search not found',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_NotFound),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataList_B,
        selectedMovieId: ThreeStateInt.none(),
        scrollOffset: 0,
        searchQuery: d.query_B,
        navCommand: null,
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_NotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).called(1);
      },
    );

    controllerTest(
      'full => search http error',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_HttpErr),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataList_B,
        selectedMovieId: ThreeStateInt.value(d.selectedId_18),
        scrollOffset: 0,
        searchQuery: d.query_B,
        navCommand: null,
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_HttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).called(1);
      },
    );

    controllerTest(
      'full => search other error',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_OtherErr),
      seed: () => MovieListState(
        movieCardDataList: List.empty(),
        selectedMovieId: ThreeStateInt.none(),
        scrollOffset: 0,
        searchQuery: d.query_A,
        navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
        // restoreView: false,
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_OtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).called(1);
      },
    );
  });

  // SEARCH SUCCESSFUL
  group('search movies => successful', () {
    controllerTest(
      'empty list => search => successful A',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_A),
      seed: () => MovieListState(),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataList_A,
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_A,
          navCommand: NavProgressOff(),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_A)).called(1);
      },
    );

    controllerTest(
      'full list => search => successful B',
      build: () => MovieListController(),
      act: (controller) => controller.fetchSearchedMovies(d.query_B),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      ),
      skip: 1,
      asyncTicks: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataList_B,
          selectedMovieId: ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: d.query_B,
          navCommand: NavProgressOff(),
        )
      ],
      verify: () {
        verify(mockDataMovieRepository.getSearchedMovies(d.query_B)).called(1);
      },
    );
  });
}
