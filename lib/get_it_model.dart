import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:get_it/get_it.dart';

import 'common/config/app_config.dart';
import 'common/ui_localized_texts/txt.dart';
import 'common/utils/date_time_reader.dart';
import 'features/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'navigation/app_navigator.dart';
import 'features/movie_list/view/movie_list_view.dart';

GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerSingleton(Txt());
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());
  getit.registerLazySingleton(() => AppNavigator(
        getit<Txt>(),
        getit<MovieListNavigator>(),
        getit<TwoButtonNavigator>(),
      ));
  getit.registerLazySingleton(() => MovieListNavigator(
        getit<Txt>(),
        getit<MovieDetailsController>(),
      ));
  getit.registerLazySingleton(() => MoviesRepository(getit<Txt>()));
  getit.registerLazySingleton(() => TwoButtonNavigator());
  getit.registerFactory(() => MovieDetailsController(getit<Txt>(), getit<DateTimeReader>(), getit<AppConfig>()));
  getit.registerFactory(() => MovieListScrollController());
}
