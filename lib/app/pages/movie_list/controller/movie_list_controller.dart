import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../../domain/repositories/movie_repository/movie_repository_exception.dart';
import '../../../../domain/utils/logging/logging_actions.dart';
import '../../../../bootstrap/get_it_model.dart';
import '../../../components/dialogs/e_dialog_msg.dart';
import '../../../components/sorting/sorter.dart';
import '../../../navigation/app_nav_commands.dart';

class MovieListController extends Controller {
  MovieListState state;
  final MovieListPresenter _movieListPresenter;
  final LoggingActions _loggingActions;
  final Sorter<Movie> _sorter;

  bool restoreView = false;

  MovieListController()
      : state = MovieListState(),
        _movieListPresenter = getIt<MovieListPresenter>(),
        _loggingActions = getIt<LoggingActions>(),
        _sorter = Sorter<Movie>(),
        super();

  @override
  void initListeners() {
    _movieListPresenter.getSearchedMoviesOnNext = (movieList) => _updateMovieList(movieList);
    _movieListPresenter.getSearchedMoviesOnError = (e) {
      _loggingActions.error(e);
      _dialogErrorMovieList(e);
    };

    _movieListPresenter.getMovieDetailsOnNext = (movie) => _showMovieDetails(movie);
    _movieListPresenter.getMovieDetailsOnError = (e) {
      _loggingActions.error(e);
      _dialogErrorMovieDetails(e);
    };
  }

  void fetchSearchedMovies(String query) {
    if (query.isEmpty) return;

    _movieListPresenter.getSearchedMovies(query);

    state.update(searchQuery: query, navCommand: NavProgress());
    refreshUI();
  }

  void _updateMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      state.update(
        movieList: MovieList.empty(),
        selectedMovieId: const MovieId.none(),
        scrollOffset: 0,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      );
    } else {
      movies = _sorter.sortColumns(movies, state.sortCriteriaList)!;
      state.update(
        movieList: MovieList(totalResults: movies.length, results: movies),
        selectedMovieId: const MovieId.none(),
        scrollOffset: 0,
      );
    }
    refreshUI();
  }

  void _dialogErrorMovieList(MovieRepositoryException e) {
    state.update(
        movieList: MovieList.empty(),
        selectedMovieId: const MovieId.none(),
        scrollOffset: 0,
        navCommand: NavErrorDialog(e));
    refreshUI();
  }

  void fetchMovie() {
    if (state.selectedMovieId == MovieId.none()) {
      state.update(navCommand: NavMessageDialog(EDialogMsg.noMovieSelected));
    } else {
      _movieListPresenter.getMovieDetails(state.selectedMovieId.id!);
      state.update(navCommand: NavProgress());
    }
    refreshUI();
  }

  void _showMovieDetails(Movie? movie) {
    if (movie == null) {
      state.update(navCommand: NavMessageDialog(EDialogMsg.noSuchMovie));
    } else {
      state.update(navCommand: NavMovieDetails(movie));
    }
    refreshUI();
  }

  void _dialogErrorMovieDetails(MovieRepositoryException e) {
    state.update(navCommand: NavErrorDialog(e));
    refreshUI();
  }

  void setSelectedMovieId(int movieId) {
    state.update(selectedMovieId: MovieId.value(movieId));
    refreshUI();
  }

  int? getSelectedMovieId() {
    return state.selectedMovieId.id;
  }

  void navTwoButtons(String searchQuery, double scrollOffset) {
    state.update(
      searchQuery: searchQuery,
      scrollOffset: scrollOffset,
      navCommand: NavTwoButtons(),
    );
    refreshUI();
  }
}
