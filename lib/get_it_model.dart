import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:get_it/get_it.dart';

import 'common/config/app_config.dart';
import 'common/utils/date_time_reader.dart';
import 'components/search_box.dart';
import 'features/movie_details/utils/movie_details_controller.dart';
import 'features/movie_list/bloc/movie_list_bloc.dart';
import 'features/movie_list/bloc/movie_list_state.dart';
import 'features/movie_list/view/movie_list_view.dart';


// no camelback for easier typing of "getit"
GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerLazySingleton(() => MoviesRepository());
  getit.registerLazySingleton(() => MovieListState());
  getit.registerLazySingleton(() => MovieListScrollController());
  getit.registerLazySingleton(() => SearchMoviesTextEditingController());
  getit.registerLazySingleton(() => MovieListBloc(moviesRepository: getit<MoviesRepository>()));
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());
  getit.registerLazySingleton(() => MovieDetailsController());
}
