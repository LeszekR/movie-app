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
  final MockAppParams mockAppParams = MockAppParams();
  final MockMovieRepository mockMovieRepository = MockMovieRepository();
  final MovieListTestData d = MovieListTestData();
  when(mockAppParams.param(AppParams.starRatingThreshold)).thenReturn('60');
  d.init(mockAppParams, mockMovieRepository);

  setUp(() {
    when(mockMovieRepository.getMovie(d.movieIdA2))
        .thenAnswer((_) => Future.value(d.movieListA.results[d.movieIdA2]));
    when(mockMovieRepository.getMovie(d.movieIdB3))
        .thenAnswer((_) => Future.value(d.movieListB.results[d.movieIdB3]));
    when(mockMovieRepository.getMovie(d.movieIdErrHttp)).thenThrow(d.errMovieHttp);
    when(mockMovieRepository.getMovie(d.movieIdErrOther)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockMovieRepository);
  });

  blocTest(
    'show movie details => show progress',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdA2),
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryA,
      navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset8)),
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
        scrollOffset: d.scrollOffset8,
        searchQuery: d.queryA,
        navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
      ),
    ],
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieIdA2)).called(1);
    },
  );

  blocTest(
    'show movie details => none selected',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryB,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset8)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        scrollOffset: d.scrollOffset8,
        searchQuery: d.queryB,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ),
    ],
    verify: (bloc) {
      verifyNever(mockMovieRepository.getMovie(any));
    },
  );

  blocTest(
    'show movie details => http error',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      selectedMovieId: ThreeStateInt.value(d.movieIdErrHttp),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryB,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.movieIdErrHttp),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryB,
        navCommand: NavErrorDialog(d.errMovieHttp),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieIdErrHttp)).called(1);
    },
  );

  blocTest(
    'show movie details => other error',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdErrOther),
      scrollOffset: d.scrollOffset230,
      searchQuery: d.queryA,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdErrOther),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavErrorDialog(d.errRepoOther),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieIdErrOther)).called(1);
    },
  );

  blocTest(
    'show movie details => success',
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListB,
      selectedMovieId: ThreeStateInt.value(d.movieIdB3),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryB,
    ),
    act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.movieIdB3),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryB,
        navCommand: NavMovieDetails(d.movieListB.results[d.movieIdB3]),
      ),
    ],
    skip: 1,
    verify: (bloc) {
      verify(mockMovieRepository.getMovie(d.movieIdB3)).called(1);
    },
  );
}
