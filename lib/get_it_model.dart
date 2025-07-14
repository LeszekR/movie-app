import 'package:flutter_recruitment_task/app/pages/movie_list/movie_list_view.dart';
import 'package:flutter_recruitment_task/data/app_config.dart';
import 'package:flutter_recruitment_task/domain/utils/date_time_reader.dart';
import 'package:get_it/get_it.dart';

import 'app/components/search_box.dart';
import 'app/pages/movie_details/movie_details_controller.dart';
import 'app/pages/movie_list/controller/movie_list_controller.dart';
import 'app/pages/movie_list/controller/state/movie_list_view_state_data.dart';
import 'app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'app/utils/sorting/sorter.dart';
import 'data/repositories/data_movies_repository.dart';
import 'domain/entities/movie.dart';
import 'domain/usecases/get_movie_details_usecase.dart';
import 'domain/usecases/get_searched_movies_usecase/get_searched_movies_usecase_factory.dart';

GetIt getit = GetIt.instance;

void initGetIt() {
  getit.registerLazySingleton(() => DataMoviesRepository());

  getit.registerLazySingleton(() => GetMovieDetailsUseCase(getit<DataMoviesRepository>()));

  getit.registerLazySingleton(() => GetSearchedMoviesUseCaseFactory());

  getit.registerLazySingleton(() => MovieListPresenter(
        getit<GetMovieDetailsUseCase>(),
        getit<GetSearchedMoviesUseCaseFactory>()(),
      ));

  getit.registerLazySingleton(() => MovieListViewStateData());
  
  getit.registerLazySingleton(() => SearchMoviesTextEditingController());
  getit.registerLazySingleton(() => MovieListScrollController());

  getit.registerLazySingleton(() => MovieListController(
        getit<MovieListPresenter>(),
        getit<MovieListViewStateData>(),
        getit<MovieListScrollController>(),
        getit<SearchMoviesTextEditingController>(),
        Sorter<Movie>(),
      ));

  getit.registerSingleton(() => AppConfig());
  getit.registerSingleton(() => DateTimeReader());
  getit.registerLazySingleton(() => MovieDetailsController(getit<DateTimeReader>(),getit<AppConfig>()));


}
