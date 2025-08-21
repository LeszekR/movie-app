import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/components/three_state_value.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_state.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools/mocks/common_mocks.mocks.dart';
import 'movie_list_bloc_test_data.dart';

void main() {
  MockAppParams mockAppParams = MockAppParams();
  MockMovieRepository mockMovieRepository = MockMovieRepository();
  when(mockAppParams.param(AppParams.starRatingThreshold)).thenReturn('60');
  MovieListTestData d = MovieListTestData();
  d.init(mockAppParams, mockMovieRepository);

  blocTest(
    'show two buttons view',
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataList_A,
      selectedMovieId: ThreeStateInt.value(d.movieId_A2),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.query_A,
      navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
    ),
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    act: (bloc) => bloc.add(ShowTwoButtonsEvent(d.scrollOffset_230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataList_A,
        selectedMovieId: ThreeStateInt.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavTwoButtons(),
      )
    ],
    verify: (bloc) {
      verifyNever(mockMovieRepository.getMovie(any));
    },
  );
}

