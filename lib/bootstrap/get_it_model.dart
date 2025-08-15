import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_cubit.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:get_it/get_it.dart';

import '../common/config/app_config.dart';
import '../common/ui_localized_texts/txt.dart';
import '../common/utils/date_time_reader.dart';
import '../components/dialogs/dialog_factory.dart';
import '../features/movie_details/model/movie.dart';
import '../features/movie_list/bloc/movie_list_bloc.dart';
import '../features/two_buttons/bloc/two_button_state.dart';
import '../features/two_buttons/two_button_navigation/two_button_navigator.dart';
import '../navigation/app_navigator.dart';

GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerSingleton(Txt());
  getit.registerSingleton(AppConfig());
  getit.registerSingleton(DateTimeReader());

  getit.registerLazySingleton(() => AppNavigator(
        getit<Txt>(),
        getit<DialogFactory>(),
        getit<MovieListNavigator>(),
        getit<TwoButtonNavigator>(),
      ));
  getit.registerLazySingleton(() => MovieListNavigator(
        getit<Txt>(),
        getit<MovieDetailsController>(),
      ));
  getit.registerLazySingleton(() => TwoButtonNavigator());

  getit.registerFactory(() => DialogFactory(getit<Txt>()));
  getit.registerFactory(() => MoviesRepository());
  getit.registerFactory(() => Sorter<Movie>());

  getit.registerLazySingleton(() => MovieListBloc(getit<MoviesRepository>(), getit<Sorter<Movie>>()));

  getit.registerLazySingleton(() => TwoButtonCubit(TwoButtonState(buttonStates: [false, false], navCommand: null)));

  getit.registerFactory(() => MovieDetailsController(getit<DateTimeReader>(), getit<AppConfig>()));
}
