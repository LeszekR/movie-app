import 'package:flutter_demo/app/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_details/utils/movie_details_utils.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_controller.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_state.dart';
import 'package:flutter_demo/app/pages/two_buttons/navigation/two_buttons_navigator.dart';
import 'package:flutter_demo/app/pages/two_buttons/presenter/two_buttons_presenter.dart';
import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/services/sorting/sorter.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/sort_movies_use_case.dart';
import 'package:flutter_demo/domain/usecases/two_buttons/click_two_button_usecase.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  // data
  getIt.registerFactory(DataMovieRepository.new);

  // app
  getIt.registerSingleton(Txt());
  getIt.registerSingleton(AppParams());
  getIt.registerSingleton(MovieAppState());
  getIt.registerSingleton(MovieAppController());

  getIt.registerLazySingleton(AppNavigator.new);
  getIt.registerFactory(() => MovieListNavigator(getIt<AppNavigator>()));
  getIt.registerFactory(() => TwoButtonsNavigator(getIt<AppNavigator>()));

  getIt.registerFactory(DateTimeReader.new);
  getIt.registerFactory(DialogFactory.new);
  getIt.registerFactory(Sorter<Movie>.new);

  getIt.registerLazySingleton(MovieListState.new);
  getIt.registerFactory(MovieListPresenter.new);
  getIt.registerFactory(MovieListController.new);

  getIt.registerLazySingleton(TwoButtonsState.new);
  getIt.registerFactory(TwoButtonsPresenter.new);
  getIt.registerFactory(TwoButtonsController.new);

  getIt.registerFactory(MovieDetailsUtils.new);

  // domain
  getIt.registerFactory(() => GetMovieDetailsUseCase(getIt<DataMovieRepository>()));
  getIt.registerFactory(() => GetSearchedMoviesUseCase(getIt<DataMovieRepository>()));
  getIt.registerFactory(() => SortMoviesUseCase(getIt<Sorter<Movie>>()));

  getIt.registerFactory(ClickTwoButtonUseCase.new);
}
