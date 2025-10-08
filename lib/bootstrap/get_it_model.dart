import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/pages/movie_app/bloc/movie_app_cubit.dart';
import 'package:flutter_demo/pages/movie_app/bloc/movie_app_state.dart';
import 'package:flutter_demo/pages/movie_details/model/movie.dart';
import 'package:flutter_demo/pages/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/pages/two_buttons/bloc/two_button_cubit.dart';
import 'package:flutter_demo/pages/two_buttons/bloc/two_button_state.dart';
import 'package:flutter_demo/pages/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'package:flutter_demo/pages/two_buttons/view/two_buttons_view.dart';
import 'package:flutter_demo/repositories/movie_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  getIt.registerSingleton(Txt());
  getIt.registerSingleton(AppParams());
  getIt.registerSingleton(DateTimeReader());
  getIt.registerFactory(() => DialogFactory(getIt<Txt>()));
  getIt.registerSingleton(MovieAppState());
  getIt.registerSingleton(MovieAppCubit());

  getIt.registerLazySingleton(() => MovieListNavigator(
        getIt<Txt>(),
        getIt<MovieDetailsController>(),
      ),);
  getIt.registerLazySingleton(TwoButtonNavigator.new);

  getIt.registerFactory(MovieRepository.new);
  getIt.registerFactory(Sorter<Movie>.new);

  getIt.registerLazySingleton(() => MovieListBloc(
        getIt<AppParams>(),
        getIt<MovieRepository>(),
        getIt<Sorter<Movie>>(),
      ),);
  getIt.registerFactory(() => MovieListView(
        txt: getIt<Txt>(),
        moviesNavigator: getIt<MovieListNavigator>(),
      ),);

  getIt.registerLazySingleton(() => TwoButtonCubit(TwoButtonState(buttonStates: const [true, true])));
  getIt.registerFactory<TwoButtonsView>(() => TwoButtonsView(
        txt: getIt<Txt>(),
        twoButtonNavigator: getIt<TwoButtonNavigator>(),
      ),);

  getIt.registerFactory(() => MovieDetailsController(getIt<DateTimeReader>(), getIt<AppParams>()));

  getIt.registerSingleton(AppNavigator(
    getIt<Txt>(),
    getIt<DialogFactory>(),
    getIt<MovieListNavigator>(),
    getIt<TwoButtonNavigator>(),
  ),);
}
