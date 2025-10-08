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
  final MockAppParams mockAppParams = MockAppParams();
  final MockMovieRepository mockMovieRepository = MockMovieRepository();
  when(mockAppParams.param(AppParams.starRatingThreshold)).thenReturn('60');
  final MovieListTestData d = MovieListTestData();
  d.init(mockAppParams, mockMovieRepository);

  blocTest(
    'show two buttons view',
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdA2),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryA,
      navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
    ),
    build: () => d.makeMovieListBloc(mockAppParams, mockMovieRepository),
    act: (bloc) => bloc.add(ShowTwoButtonsEvent(d.scrollOffset230)),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset230,
        searchQuery: d.queryA,
        navCommand: NavTwoButtons(),
      ),
    ],
    verify: (bloc) {
      verifyNever(mockMovieRepository.getMovie(any));
    },
  );
}
