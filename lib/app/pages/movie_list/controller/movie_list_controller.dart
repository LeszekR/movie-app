import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/bootstrap/logger_messages.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';

import '../../../../bootstrap/get_it_model.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../../domain/repositories/movie_repository/movie_repository_exception.dart';
import '../../../components/dialogs/e_dialog_msg.dart';
import '../../../components/sorting/sorter.dart';
import '../../../components/three_state_value.dart';
import '../../../navigation/app_nav_commands.dart';

class MovieListController extends Controller {
  MovieListState state;
  final MovieListPresenter _movieListPresenter;
  final Sorter<Movie> _sorter;

  MovieListController()
      : state = getIt<MovieListState>(),
        _movieListPresenter = getIt<MovieListPresenter>(),
        _sorter = getIt<Sorter<Movie>>(),
        super();

  @override
  void initListeners() {
    _movieListPresenter.getSearchedMoviesOnNext = (movieList) => _updateMovieList(movieList);
    _movieListPresenter.getSearchedMoviesOnError = (e) {
      log.severe(logErrSearchMovies, e);
      _dialogErrorMovieList(e);
    };

    _movieListPresenter.getMovieDetailsOnNext = (movie) => _showMovieDetails(movie);
    _movieListPresenter.getMovieDetailsOnError = (e) {
      log.severe(logErrMovieDetails, e);
      _dialogErrorMovieDetails(e);
    };
  }

  void fetchSearchedMovies(String query) {
    if (query.isEmpty) return;
    if (query == state.searchQuery) return;

    _movieListPresenter.getSearchedMovies(query);

    state.update(searchQuery: query, navCommand: NavProgressOn());
    refreshUI();
  }

  void _updateMovieList(List<Movie> movies) async {
    if (movies.isEmpty) {
      state.update(
        movieList: MovieList.empty(),
        selectedMovieId: const ThreeStateInt.none(),
        scrollOffset: 0,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      );
    } else {
      movies = _sorter.sortColumns(movies, state.sortCriteriaList)!;
      state.update(
        movieList: MovieList(totalResults: movies.length, results: movies),
        selectedMovieId: const ThreeStateInt.none(),
        scrollOffset: 0,
        navCommand: NavProgressOff(),
      );
    }
    refreshUI();
  }

  void _dialogErrorMovieList(MovieRepositoryException e) {
    state.update(
        movieList: MovieList.empty(),
        selectedMovieId: const ThreeStateInt.none(),
        scrollOffset: 0,
        navCommand: NavErrorDialog(e));
    refreshUI();
  }

  void fetchMovie() {
    if (!state.selectedMovieId.hasValue) {
      state.update(navCommand: NavMessageDialog(EDialogMsg.noMovieSelected));
    } else {
      _movieListPresenter.getMovieDetails(state.selectedMovieId.value!);
      state.update(navCommand: NavProgressOn());
    }
    refreshUI();
  }

  void _showMovieDetails(Movie? movie) {
    if (movie == null) {
      state.update(navCommand: NavMessageDialog(EDialogMsg.noSuchMovie));
    } else {
      state.update(
        navCommand: NavMovieDetails(movie),
        restoreView: true,
      );
    }
    refreshUI();
  }

  void _dialogErrorMovieDetails(MovieRepositoryException e) {
    state.update(navCommand: NavErrorDialog(e));
    refreshUI();
  }

  void setSelectedMovieId(int movieId) {
    state.update(selectedMovieId: ThreeStateInt.value(movieId));
    refreshUI();
  }

  int? getSelectedMovieId() {
    return state.selectedMovieId.value;
  }

  void navTwoButtons() {
    state.update(navCommand: NavTwoButtons());
    refreshUI();
  }

  void saveState(String searchQuery, double scrollOffset) {
    state.update(
      searchQuery: searchQuery,
      scrollOffset: scrollOffset,
      restoreView: true,
    );
  }

  void setViewRestored() {
    state.update(restoreView: false);
  }
}
