import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/common_mocks.mocks.dart';
import 'movie_list_bloc_test_data.dart';

void main() {
  MockMoviesRepository mockMoviesRepository = MockMoviesRepository();
  MovieListTestData d = MovieListTestData();

  setUp(() {
    when(mockMoviesRepository.getMovie(d.movieId_A2))
        .thenAnswer((_) => Future.value(d.movieList_A.results[d.movieId_A2]));
    when(mockMoviesRepository.getMovie(d.movieId_B3))
        .thenAnswer((_) => Future.value(d.movieList_B.results[d.movieId_B3]));
    when(mockMoviesRepository.getMovie(d.movieId_ErrHttp)).thenThrow(d.errMovieHttp);
    when(mockMoviesRepository.getMovie(d.movieId_ErrOther)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockMoviesRepository);
  });

  blocTest(
    'show movie details => show progress',
    build: () => d.makeMovieListBloc(mockMoviesRepository),
    seed: () => MovieListState(
      movieList: d.movieList_A,
      selectedMovieId: MovieId.value(d.movieId_A2),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
    expect: () => [
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: MovieId.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavProgress(),
      ),
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: MovieId.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_8,
        searchQuery: d.query_A,
        navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
      )
    ],
    verify: (bloc) {
      verify(mockMoviesRepository.getMovie(d.movieId_A2)).called(1);
    },
  );

  blocTest(
    'show movie details => none selected',
    build: () => d.makeMovieListBloc(mockMoviesRepository),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: MovieId.none(),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: MovieId.none(),
        scrollOffset: d.scrollOffset_8,
        searchQuery: d.query_B,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ),
    ],
    skip: 0,
    verify: (bloc) {
      verifyNever(mockMoviesRepository.getMovie(any));
    },
  );

  blocTest(
    'show movie details => http error',
    build: () => d.makeMovieListBloc(mockMoviesRepository),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: MovieId.value(d.movieId_ErrHttp),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: MovieId.value(d.movieId_ErrHttp),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavErrorDialog(d.errMovieHttp),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMoviesRepository.getMovie(d.movieId_ErrHttp)).called(1);
    },
  );

  blocTest(
    'show movie details => other error',
    build: () => d.makeMovieListBloc(mockMoviesRepository),
    seed: () => MovieListState(
      movieList: d.movieList_A,
      selectedMovieId: MovieId.value(d.movieId_ErrOther),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieList: d.movieList_A,
        selectedMovieId: MovieId.value(d.movieId_ErrOther),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavErrorDialog(d.errRepoOther),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMoviesRepository.getMovie(d.movieId_ErrOther)).called(1);
    },
  );

  blocTest(
    'show movie details => success',
    build: () => d.makeMovieListBloc(mockMoviesRepository),
    seed: () => MovieListState(
      movieList: d.movieList_B,
      selectedMovieId: MovieId.value(d.movieId_B3),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieList: d.movieList_B,
        selectedMovieId: MovieId.value(d.movieId_B3),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavMovieDetails(d.movieList_B.results[d.movieId_B3]),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMoviesRepository.getMovie(d.movieId_B3)).called(1);
    },
  );
}
