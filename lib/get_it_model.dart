import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_state.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

import 'app/components/dialogs/dialog_factory.dart';
import 'app/config/app_config.dart';
import 'app/pages/movie_details/utils/movie_details_utils.dart';
import 'app/pages/movie_list/controller/movie_list_controller.dart';
import 'app/pages/movie_list/controller/movie_list_state.dart';
import 'app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'app/pages/two_buttons/controller/two_buttons_controller.dart';
import 'app/pages/two_buttons/presenter/two_buttons_presenter.dart';
import 'app/pages/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'data/repositories/movie_repository/data_movie_repository.dart';
import 'domain/ui_localized_texts/txt.dart';
import 'domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'domain/usecases/two_buttons/click_button_usecase.dart';
import 'domain/utils/logging/logging_actions.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  getIt.registerSingleton(Txt());
  getIt.registerSingleton(AppConfig());
  getIt.registerSingleton(DateTimeReader());
  getIt.registerSingleton(LoggingActions());
  getIt.registerLazySingleton(() => DialogFactory());
  getIt.registerLazySingleton(() => MovieListNavigator());
  getIt.registerLazySingleton(() => TwoButtonNavigator());
  getIt.registerSingleton(AppNavigator());

  getIt.registerLazySingleton(() => MovieListState());
  getIt.registerFactory(() => DataMovieRepository());
  getIt.registerFactory(() => GetMovieDetailsUseCase(getIt<DataMovieRepository>()));
  getIt.registerFactory(() => GetSearchedMoviesUseCase());
  getIt.registerFactory(() => MovieListPresenter());
  getIt.registerFactory(() => MovieListController());

  getIt.registerFactory(() => MovieDetailsUtils());
  
  getIt.registerLazySingleton(() => TwoButtonsState());
  getIt.registerFactory(() => ClickButtonUseCase());
  getIt.registerFactory(() => TwoButtonsPresenter());
  getIt.registerFactory(() => TwoButtonsController());
}
