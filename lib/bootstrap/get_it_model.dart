import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_state.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

import '../app/components/dialogs/dialog_factory.dart';
import '../app/components/sorting/sorter.dart';
import '../app/pages/movie_details/utils/movie_details_utils.dart';
import '../app/pages/movie_list/controller/movie_list_controller.dart';
import '../app/pages/movie_list/controller/movie_list_state.dart';
import '../app/pages/movie_list/presenter/movie_list_presenter.dart';
import '../app/pages/two_buttons/controller/two_buttons_controller.dart';
import '../app/pages/two_buttons/presenter/two_buttons_presenter.dart';
import '../app/pages/two_buttons/two_buttons_navigation/two_buttons_navigator.dart';
import '../data/repositories/movie_repository/data_movie_repository.dart';
import '../domain/entities/movie.dart';
import '../domain/ui_localized_texts/txt.dart';
import '../domain/usecases/movie_details/get_movie_details_usecase.dart';
import '../domain/usecases/movie_list/get_searched_movies_usecase.dart';
import '../domain/usecases/two_buttons/click_two_button_usecase.dart';
import 'app_params.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  // data
  getIt.registerFactory(() => DataMovieRepository());

  // app
  getIt.registerSingleton(Txt());
  getIt.registerSingleton(AppParams());
  getIt.registerSingleton(MovieAppState());
  getIt.registerSingleton(MovieAppController());

  getIt.registerLazySingleton(() => AppNavigator());
  getIt.registerFactory(() => MovieListNavigator(getIt<AppNavigator>()));
  getIt.registerFactory(() => TwoButtonsNavigator(getIt<AppNavigator>()));

  getIt.registerFactory(() => DateTimeReader());
  getIt.registerFactory(() => DialogFactory());
  getIt.registerFactory(() => Sorter<Movie>());

  getIt.registerLazySingleton(() => MovieListState());
  getIt.registerFactory(() => MovieListPresenter());
  getIt.registerFactory(() => MovieListController());

  getIt.registerLazySingleton(() => TwoButtonsState());
  getIt.registerFactory(() => TwoButtonsPresenter());
  getIt.registerFactory(() => TwoButtonsController());

  getIt.registerFactory(() => MovieDetailsUtils());

  // domain
  getIt.registerFactory(() => GetMovieDetailsUseCase(getIt<DataMovieRepository>()));
  getIt.registerFactory(() => GetSearchedMoviesUseCase(getIt<DataMovieRepository>()));

  getIt.registerFactory(() => ClickTwoButtonUseCase());
}
