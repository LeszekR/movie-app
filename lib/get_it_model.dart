import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:get_it/get_it.dart';

import 'common/config/app_config.dart';
import 'common/utils/date_time_reader.dart';
import 'features/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'navigation/app_navigator.dart';


// no camelback for quicker typing of "getit"
GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerLazySingleton(() => MoviesRepository());
  getit.registerLazySingleton(() => AppNavigator());
  getit.registerLazySingleton(() => TwoButtonNavigator(getit<AppNavigator>()));
  getit.registerLazySingleton(() => MovieListNavigator(getit<AppNavigator>()));
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());
  getit.registerFactory(() => MovieDetailsController());
}
