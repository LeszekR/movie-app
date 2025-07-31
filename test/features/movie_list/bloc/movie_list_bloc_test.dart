import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/common/config/app_config.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/model/movie_list.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_demo/repositories/movies_repository_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

part 'movie_list_bloc_test_data.dart';

GetIt getit = GetIt.instance;
var errSearchHttp = MovieListHttpException(404);
var errMovieHttp = MovieDetailsHttpException(404);
var errRepoOther = Exception('other exception');

@GenerateMocks([MoviesRepository, AppNavigator, MovieListNavigator, Txt])
void main() {
  MockMoviesRepository mockMoviesRepository;
  late MovieListBloc movieListBloc;
  

  setUpAll(() {
    mockMoviesRepository = MockMoviesRepository();

    getit.registerSingleton<Txt>(MockTxt());
    getit.registerSingleton(AppConfig());
    getit.registerSingleton<DateTimeReader>(DateTimeReader());
    getit.registerLazySingleton(() => mockMoviesRepository);
    getit.registerLazySingleton(() => MockAppNavigator());
    getit.registerLazySingleton(() => MockMovieListNavigator());
    getit.registerLazySingleton(() => TwoButtonNavigator());
    getit.registerSingleton(() => MovieDetailsController(getit<DateTimeReader>(), getit<AppConfig>()));
    getit.registerLazySingleton(() => Sorter<Movie>());

    when(mockMoviesRepository.getSearchedMovies(_searchQuery_A))
        .thenAnswer((_) => Future.value(_testMovieList_A().results));
    when(mockMoviesRepository.getSearchedMovies(_searchQuery_B))
        .thenAnswer((_) => Future.value(_testMovieList_B().results));
    when(mockMoviesRepository.getSearchedMovies(_searchQueryNotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockMoviesRepository.getSearchedMovies(_searchQueryHttpErr)).thenThrow(errSearchHttp);
    when(mockMoviesRepository.getSearchedMovies(_searchQueryOtherErr)).thenThrow(errRepoOther);

    when(mockMoviesRepository.getMovie(_movieId_A2))
        .thenAnswer((_) => Future.value(_testMovieList_A().results[_movieId_A2]));
    when(mockMoviesRepository.getMovie(_movieId_B6))
        .thenAnswer((_) => Future.value(_testMovieList_B().results[_movieId_B6]));
    when(mockMoviesRepository.getMovie(_movieIdErrHttp)).thenThrow(errMovieHttp);
    when(mockMoviesRepository.getMovie(_movieIdErrOther)).thenThrow(errRepoOther);

    movieListBloc = MovieListBloc(mockMoviesRepository, getit<Sorter<Movie>>());
  });

  tearDown(() {
    getit.reset();
  });

  group('MovieListBloc event => state with state maintained', () {
    for (var testCase in testCasesList) {
      blocTest(
        testCase.title,
        build: () => movieListBloc, // we keep the same object to test parts of the state that should be maintained
        act: (bloc) => bloc.add(testCase.event),
        expect: () => testCase.state,
      );
    }
  });
}

var testCasesList = [
  _MovieListBlocTestCase(
    '2 search OK',
    SearchMoviesEvent(_searchQuery_A),
    MovieListState(
      movieList: _testMovieList_A(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQuery_A,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '3 select',
    SelectMovieEvent(_selectedId_1, _scrollOffset_1),
    MovieListState(
      movieList: _testMovieList_A(),
      selectedMovieId: MovieId.value(_selectedId_1),
      scrollOffset: _scrollOffset_1,
      searchQuery: _searchQuery_A,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '4 search OK',
    SearchMoviesEvent(_searchQuery_B),
    MovieListState(
      movieList: _testMovieList_B(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '5 search not found',
    SearchMoviesEvent(_searchQueryNotFound),
    MovieListState(
      movieList: _movieListEmpty(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQueryNotFound,
      navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
    ),
  ),
  //
  _MovieListBlocTestCase(
    '6 search OK',
    SearchMoviesEvent(_searchQuery_B),
    MovieListState(
      movieList: _testMovieList_B(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '7 select',
    SelectMovieEvent(_selectedId_3, _scrollOffset_3),
    MovieListState(
      movieList: _testMovieList_A(),
      selectedMovieId: MovieId.value(_selectedId_3),
      scrollOffset: _scrollOffset_3,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '8 search other error',
    SearchMoviesEvent(_searchQueryHttpErr),
    MovieListState(
      movieList: _movieListEmpty(),
      scrollOffset: 0,
      selectedMovieId: MovieId.none(),
      searchQuery: _searchQueryHttpErr,
      navCommand: NavErrorDialog(errSearchHttp),
    ),
  ),
  //
  _MovieListBlocTestCase(
    '9 search OK',
    SearchMoviesEvent(_searchQuery_A),
    MovieListState(
      movieList: _testMovieList_A(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQuery_A,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '10 select',
    SelectMovieEvent(_selectedId_3, _scrollOffset_3),
    MovieListState(
      movieList: _testMovieList_A(),
      selectedMovieId: MovieId.value(_selectedId_3),
      scrollOffset: _scrollOffset_3,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '11 show movie details',
    ShowMovieDetailsEvent(MovieId.value(_movieId_A2), _scrollOffset_1),
    MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.value(_movieId_A2),
        scrollOffset: _scrollOffset_1,
        searchQuery: _searchQuery_B,
        navCommand: NavMovieDetails(_testMovieList_A().results[_movieId_A2])),
  ),
  //
  _MovieListBlocTestCase(
    '12 search other error',
    SearchMoviesEvent(_searchQueryOtherErr),
    MovieListState(
      movieList: _movieListEmpty(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQueryOtherErr,
      navCommand: NavErrorDialog(errRepoOther),
    ),
  ),
  //
  _MovieListBlocTestCase(
    '13 search OK',
    SearchMoviesEvent(_searchQuery_B),
    MovieListState(
      movieList: _testMovieList_B(),
      selectedMovieId: MovieId.none(),
      scrollOffset: 0,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  //
  _MovieListBlocTestCase(
    '14 select',
    SelectMovieEvent(_movieId_B6, _scrollOffset_5),
    MovieListState(
      movieList: _testMovieList_B(),
      selectedMovieId: MovieId.value(_movieId_B6),
      scrollOffset: _scrollOffset_5,
      searchQuery: _searchQuery_B,
      navCommand: null,
    ),
  ),
  _MovieListBlocTestCase(
    '15 show two buttons',
    ShowTwoButtonsEvent(150),
    MovieListState(
      movieList: _testMovieList_B(),
      selectedMovieId: MovieId.value(_movieId_B6),
      scrollOffset: _scrollOffset_5,
      searchQuery: _searchQuery_B,
      navCommand: NavTwoButtons(),
    ),
  ),
];
