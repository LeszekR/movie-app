import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_tools/controller_test/controller_test_runner.dart';
import '../../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../../test_tools/test_utils.dart';
import 'movie_list_controller_test_data.dart';

void main() {
  final MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
  final MovieListTestData d = MovieListTestData();

  setUpAll(() async {
    await loadConfigFile();
    initGetIt();
    getItReplaceFactory<DataMovieRepository>(() => mockDataMovieRepository);
    getItReplaceFactory<GetSearchedMoviesUseCase>(() => GetSearchedMoviesUseCase(mockDataMovieRepository));
    getItReplaceFactory<GetMovieDetailsUseCase>(() => GetMovieDetailsUseCase(mockDataMovieRepository));
    await d.init();
  });

  controllerTest(
    'show two buttons view',
    seed: () => MovieListState(
      movieCardDataList: d.movieCardDataListA,
      selectedMovieId: ThreeStateInt.value(d.movieIdA2),
      scrollOffset: d.scrollOffset_8,
      searchQuery: d.queryA,
      navCommand: NavMovieDetails(d.movieListA.results[d.movieIdA2]),
    ),
    build: MovieListController.new,
    act: (controller) => controller.navTwoButtons(),
    expect: () => [
      MovieListState(
        movieCardDataList: d.movieCardDataListA,
        selectedMovieId: ThreeStateInt.value(d.movieIdA2),
        scrollOffset: d.scrollOffset_8,
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
