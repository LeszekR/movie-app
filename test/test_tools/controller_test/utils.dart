import 'package:flutter_demo/app/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/app/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/services/sorting/sorter.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/sort_movies_use_case.dart';

final appParams = AppParams();
const _dialogFactory = DialogFactory();
final _appNavigator = AppNavigator(_dialogFactory);
final _movieListNavigator = MovieListNavigator(_appNavigator);

MovieListController makeMovieListController(DataMovieRepository movieRepository) {
  final getMovieDetailsUseCase = GetMovieDetailsUseCase(movieRepository);
  final getSearchedMoviesUseCase = GetSearchedMoviesUseCase(movieRepository);
  final sortMoviesUseCase = SortMoviesUseCase(Sorter());
  final movieListPresenter = MovieListPresenter(getMovieDetailsUseCase, getSearchedMoviesUseCase, sortMoviesUseCase);
  return MovieListController(appParams, movieListPresenter);
}

MovieListView makeMovieListView(DataMovieRepository movieRepository) {
  final movieAppController = MovieAppController(MovieAppState(appParams));
  return MovieListView(movieAppController, makeMovieListController(movieRepository), _movieListNavigator);
}
