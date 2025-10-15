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
  final MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    getIt.registerLazySingleton(MovieListState.new);
    await d.init();
  });

  controllerTest(
    'show two buttons view',
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdA2),
      scrollOffset: d.scrollOffset8,
      searchQuery: d.queryA,
      navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
    ),
    build: () => makeMovieListController(mockDataMovieRepository),
    act: (controller) => controller.navTwoButtons(),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset8,
        searchQuery: d.queryA,
        navCommand: NavTwoButtons(),
      ),
    ],
    verify: () {
      verifyNever(mockDataMovieRepository.getSearchedMovies(any));
      verifyNever(mockDataMovieRepository.getMovie(any));
    },
  );
}
