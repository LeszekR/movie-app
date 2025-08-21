import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/components/three_state_value.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools/mocks/common_mocks.mocks.dart';
import 'movie_list_bloc_test_data.dart';

void main() {
  MockAppParams mockAppParams = MockAppParams();
  MockMovieRepository mockMovieRepository = MockMovieRepository();
  MovieListTestData d = MovieListTestData();
  when(mockAppParams.param(AppParams.starRatingThreshold)).thenReturn('60');
  d.init(mockAppParams, mockMovieRepository);

  setUp(() {
    when(mockMovieRepository.getMovie(d.movieId_A2))
        .thenAnswer((_) => Future.value(d.movieList_A.results[d.movieId_A2]));
    when(mockMovieRepository.getMovie(d.movieId_B3))
        .thenAnswer((_) => Future.value(d.movieList_B.results[d.movieId_B3]));
    when(mockMovieRepository.getMovie(d.movieId_ErrHttp)).thenThrow(d.errMovieHttp);
    when(mockMovieRepository.getMovie(d.movieId_ErrOther)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockMovieRepository);
  });

  blocTest(
    'show movie details => show progress',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_A2),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavProgressOn(),
      ),
      MovieListState(
        movieCardDataList: d.movieCardDataList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_8,
        searchQuery: d.query_A,
        navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
      )
    ],
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieId_A2)).called(1);
    },
  );

  blocTest(
    'show movie details => none selected',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_B,
      selectedMovieId: ThreeStateInt.none(),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_B,
        selectedMovieId: ThreeStateInt.none(),
        scrollOffset: d.scrollOffset_8,
        searchQuery: d.query_B,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ),
    ],
    skip: 0,
    verify: (bloc) {
      verifyNever(mockMovieRepository.getMovie(any));
    },
  );

  blocTest(
    'show movie details => http error',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_B,
      selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_B,
        selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavErrorDialog(d.errMovieHttp),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieId_ErrHttp)).called(1);
    },
  );

  blocTest(
    'show movie details => other error',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
      scrollOffset: d.scrollOffset_230,
      searchQuery: d.query_A,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavErrorDialog(d.errRepoOther),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieId_ErrOther)).called(1);
    },
  );

  blocTest(
    'show movie details => success',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_B,
      selectedMovieId: ThreeStateInt.value(d.movieId_B3),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_B,
      navCommand: null,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_B,
        selectedMovieId: ThreeStateInt.value(d.movieId_B3),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_B,
        navCommand: NavMovieDetails(d.movieList_B.results[d.movieId_B3]),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieId_B3)).called(1);
    },
  );
}
