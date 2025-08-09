import 'package:flutter_demo/app/pages/movie_list/movie_list_view.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

import 'app/components/search_box.dart';
import 'app/config/app_config.dart';
import 'app/pages/movie_details/movie_details_controller.dart';
import 'app/pages/movie_list/controller/movie_list_controller.dart';
import 'app/pages/movie_list/controller/state/movie_list_view_state_data.dart';
import 'app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'data/repositories/data_movies_repository.dart';
import 'domain/ui_localized_texts/txt.dart';
import 'domain/usecases/get_movie_details_usecase.dart';
import 'domain/usecases/get_searched_movies_usecase.dart';

// no camelback for easier typing of "getit"
GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerSingleton(Txt());
  getit.registerLazySingleton(() => DataMoviesRepository());
  getit.registerLazySingleton(() => GetMovieDetailsUseCase(getit<DataMoviesRepository>()));
  getit.registerLazySingleton(() => GetSearchedMoviesUseCase());
  getit.registerLazySingleton(() => MovieListPresenter());
  getit.registerLazySingleton(() => MovieListViewStateData());
  getit.registerLazySingleton(() => MovieListScrollController());
  getit.registerLazySingleton(() => SearchMoviesTextEditingController());
  getit.registerLazySingleton(() => MovieListController());
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());
  getit.registerLazySingleton(() => MovieDetailsController());
}
