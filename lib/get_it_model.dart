import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:get_it/get_it.dart';

import 'common/config/app_config.dart';
import 'common/utils/date_time_reader.dart';


// no camelback for quicker typing of "getit"
GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerLazySingleton(() => MoviesRepository());
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());
}
