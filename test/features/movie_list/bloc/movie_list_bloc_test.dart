import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/common/config/app_config.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
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
import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../movie_details/movie_details_test.dart';
import 'movie_list_bloc_test.mocks.dart';

part 'movie_list_bloc_test_data.dart';

@GenerateMocks([MoviesRepository, AppNavigator, MovieListNavigator])
// @GenerateNiceMocks([MockSpec<MoviesRepository>(), MockSpec<AppNavigator>(), MockSpec<MovieListNavigator>()])
void main() {
  var mockMoviesRepository = MockMoviesRepository();

  setUp(() {
    getit.registerSingleton<Txt>(Txt());
    getit.registerSingleton(AppConfig());
    getit.registerSingleton<DateTimeReader>(DateTimeReader());
    getit.registerLazySingleton(() => mockMoviesRepository);
    getit.registerLazySingleton(() => MockAppNavigator());
    getit.registerLazySingleton(() => MockMovieListNavigator());
    getit.registerLazySingleton(() => TwoButtonNavigator());
    getit.registerSingleton(DateTimeReader());
    getit.registerSingleton(() => MovieDetailsController(getit<Txt>(), getit<DateTimeReader>(), getit<AppConfig>()));
  });

  var moviesRepository = MoviesRepository(getit<Txt>());
  var errSearchHttp = moviesRepository.errSearchMovies(404);
  var errMovieHttp = moviesRepository.errMovieDetails(404);
  var errRepoOther = Exception('other exception');

  when(mockMoviesRepository.getSearchedMovies(_searchQuery_A)).thenReturn(Future.value(_testMovieList_A().results));
  when(mockMoviesRepository.getSearchedMovies(_searchQuery_B)).thenReturn(Future.value(_testMovieList_B().results));
  when(mockMoviesRepository.getSearchedMovies(_searchQueryNotFound)).thenReturn(Future.value(List.empty()));
  when(mockMoviesRepository.getSearchedMovies(_searchQueryHttpErr)).thenThrow(errSearchHttp);
  when(mockMoviesRepository.getSearchedMovies(_searchQueryOtherErr)).thenThrow(errRepoOther);

  when(mockMoviesRepository.getMovie(_movieId_A2)).thenReturn(Future.value(_testMovieList_A().results[_movieId_A2]));
  when(mockMoviesRepository.getMovie(_movieId_B6)).thenReturn(Future.value(_testMovieList_B().results[_movieId_B6]));
  when(mockMoviesRepository.getMovie(_movieIdErrHttp)).thenThrow(errMovieHttp);
  when(mockMoviesRepository.getMovie(_movieIdErrOther)).thenThrow(errRepoOther);

  var movieListBloc = MovieListBloc(getit<Txt>(), mockMoviesRepository);

  var testCasesList = [
    _MovieListBlocTestCase(
      '1 progress',
      ShowProgressEvent(),
      MovieListState(
        movieList: null,
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: null,
        navCommand: NavProgress(),
      ),
    ),
    //
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
        navCommand: NavMessageDialog(movieListBloc.dialogParamsSearchEmpty()),
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
