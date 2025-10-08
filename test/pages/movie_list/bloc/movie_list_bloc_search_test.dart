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
    when(mockMovieRepository.getSearchedMovies(d.queryA)).thenAnswer((_) => Future.value(d.movieListA.results));
    when(mockMovieRepository.getSearchedMovies(d.queryB)).thenAnswer((_) => Future.value(d.movieListB.results));
    when(mockMovieRepository.getSearchedMovies(d.queryNotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockMovieRepository.getSearchedMovies(d.queryHttpErr)).thenThrow(d.errSearchHttp);
    when(mockMovieRepository.getSearchedMovies(d.queryOtherErr)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockMovieRepository);
  });

  group('search movies - progress indicator', () {
    blocTest(
      'search show progress',
      seed: MovieListState.new,
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryA)),
      expect: () => [
        MovieListState(
          navCommand: NavProgressOn(),
        ),
        MovieListState(
          movieCardDataList: d.movieCardDataListA,
          searchQuery: d.queryA,
          navCommand: NavProgressOff(),
          restoreView: true,
        ),
      ],
    );
  });

  group('search movies - edge cases', () {
    blocTest(
      'search query null',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(null)),
      seed: MovieListState.new,
      expect: () => [],
      verify: (bloc) {
        verifyNever(mockMovieRepository.getSearchedMovies(d.queryA));
      },
    );

    blocTest(
      'search query empty string',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent('')),
      seed: MovieListState.new,
      expect: () => [],
      verify: (bloc) {
        verifyNever(mockMovieRepository.getSearchedMovies(any));
      },
    );
  });

  group('empty list => search movies => failed', () {
    blocTest(
      'empty => search not found',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryNotFound)),
      skip: 1,
      seed: MovieListState.new,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryNotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryNotFound)).called(1);
      },
    );

    blocTest(
      'empty  => search http error',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryHttpErr)),
      skip: 1,
      seed: MovieListState.new,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryHttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryHttpErr)).called(1);
      },
    );

    blocTest(
      'empty  => search other error',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryOtherErr)),
      skip: 1,
      seed: MovieListState.new,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryOtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryOtherErr)).called(1);
      },
    );
  });

  group('full list => search movies => failed', () {
    blocTest(
      'full => search not found',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryNotFound)),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListB,
        searchQuery: d.queryB,
      ),
      skip: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryNotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryNotFound)).called(1);
      },
    );

    blocTest(
      'full => search http error',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryHttpErr)),
      skip: 1,
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListB,
        selectedMovieId: ThreeStateInt.value(d.selectedId18),
        searchQuery: d.queryB,
      ),
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryHttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryHttpErr)).called(1);
      },
    );

    blocTest(
      'full => search other error',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryOtherErr)),
      skip: 1,
      seed: () => MovieListState(
        movieCardDataList: List.empty(),
        searchQuery: d.queryA,
        navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
      ),
      expect: () => [
        MovieListState(
          movieCardDataList: List.empty(),
          searchQuery: d.queryOtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryOtherErr)).called(1);
      },
    );
  });

  // SEARCH SUCCESSFUL
  group('search movies => successful', () {
    blocTest(
      'empty list => search => successful',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryA)),
      seed: MovieListState.new,
      skip: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataListA,
          searchQuery: d.queryA,
          navCommand: NavProgressOff(),
          restoreView: true,
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryA)).called(1);
      },
    );

    blocTest(
      'full list => search => successful',
      build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.queryB)),
      seed: () => MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      ),
      skip: 1,
      expect: () => [
        MovieListState(
          movieCardDataList: d.movieCardDataListB,
          searchQuery: d.queryB,
          navCommand: NavProgressOff(),
          restoreView: true,
        ),
      ],
      verify: (bloc) {
        verify(mockMovieRepository.getSearchedMovies(d.queryB)).called(1);
      },
    );
  });
}
