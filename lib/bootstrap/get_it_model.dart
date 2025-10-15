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
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository.dart';
import 'package:flutter_demo/domain/services/sorting/sorter.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/sort_movies_use_case.dart';
import 'package:flutter_demo/domain/usecases/two_buttons/click_two_button_usecase.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  getIt.registerFactory(DateTimeReader.new);
  getIt.registerLazySingleton(DialogFactory.new);
  getIt.registerFactory(Sorter<Movie>.new);

  getIt.registerFactory<MovieRepository>(DataMovieRepository.new);

  getIt.registerSingleton(AppParams());
  getIt.registerSingleton(MovieAppState(getIt<AppParams>()));
  getIt.registerSingleton(MovieAppController(getIt<MovieAppState>()));

  getIt.registerLazySingleton(() => AppNavigator(getIt<DialogFactory>()));
  getIt.registerFactory(() => MovieListNavigator(getIt<AppNavigator>()));
  getIt.registerFactory(() => TwoButtonsNavigator(getIt<AppNavigator>()));

  getIt.registerLazySingleton(MovieListState.new);

  getIt.registerFactory(() => GetMovieDetailsUseCase(getIt<MovieRepository>()));
  getIt.registerFactory(() => GetSearchedMoviesUseCase(getIt<MovieRepository>()));
  getIt.registerFactory(() => SortMoviesUseCase(getIt<Sorter<Movie>>()));

  getIt.registerFactory(
    () => MovieListPresenter(
      getIt<GetMovieDetailsUseCase>(),
      getIt<GetSearchedMoviesUseCase>(),
      getIt<SortMoviesUseCase>(),
    ),
  );
  getIt.registerFactory(() => MovieListController(getIt<AppParams>(), getIt<MovieListPresenter>()));

  getIt.registerFactory(ClickButtonUseCase.new);
  getIt.registerLazySingleton(TwoButtonsState.new);
  getIt.registerFactory(() => TwoButtonsPresenter(getIt<ClickButtonUseCase>()));
  getIt.registerFactory(() => TwoButtonsController(getIt<TwoButtonsState>(), getIt<TwoButtonsPresenter>()));

  getIt.registerFactory(() => MovieDetailsUtils(getIt<AppParams>(), getIt<DateTimeReader>()));
}
