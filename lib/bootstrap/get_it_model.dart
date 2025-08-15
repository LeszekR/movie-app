import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_cubit.dart';
import 'package:flutter_demo/features/two_buttons/view/two_buttons_view.dart';
import 'package:flutter_demo/repositories/movie_repository.dart';
import 'package:get_it/get_it.dart';

import '../common/config/app_config.dart';
import '../common/ui_localized_texts/txt.dart';
import '../common/utils/date_time_reader.dart';
import '../components/dialogs/dialog_factory.dart';
import '../features/movie_details/model/movie.dart';
import '../features/movie_list/bloc/movie_list_bloc.dart';
import '../features/movie_list/view/movie_list_view.dart';
import '../features/two_buttons/bloc/two_button_state.dart';
import '../features/two_buttons/two_button_navigation/two_button_navigator.dart';
import '../navigation/app_navigator.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  getIt.registerSingleton(Txt());
  getIt.registerSingleton(AppConfig());
  getIt.registerSingleton(DateTimeReader());
  getIt.registerFactory(() => DialogFactory(getIt<Txt>()));

  getIt.registerLazySingleton(() => MovieListNavigator(
        getIt<Txt>(),
        getIt<MovieDetailsController>(),
      ));
  getIt.registerLazySingleton(() => TwoButtonNavigator());

  getIt.registerFactory(() => MovieRepository());
  getIt.registerFactory(() => Sorter<Movie>());

  getIt.registerLazySingleton(() => MovieListBloc(getIt<MovieRepository>(), getIt<Sorter<Movie>>()));
  getIt.registerFactory(() => MovieListView(
        txt: getIt<Txt>(),
        moviesNavigator: getIt<MovieListNavigator>(),
      ));

  getIt.registerLazySingleton(() => TwoButtonCubit(TwoButtonState(buttonStates: [false, false], navCommand: null)));
  getIt.registerFactory<TwoButtonsView>(() => TwoButtonsView(
        txt: getIt<Txt>(),
        twoButtonNavigator: getIt<TwoButtonNavigator>(),
      ));

  getIt.registerFactory(() => MovieDetailsController(getIt<DateTimeReader>(), getIt<AppConfig>()));

  getIt.registerSingleton(AppNavigator(
    getIt<Txt>(),
    getIt<DialogFactory>(),
    getIt<MovieListNavigator>(),
    getIt<TwoButtonNavigator>(),
  ));
}
