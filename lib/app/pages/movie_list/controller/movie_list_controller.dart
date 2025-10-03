import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/components/three_state_value.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card_data.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/bootstrap/logger_messages.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository_exception.dart';

class MovieListController extends Controller {
  MovieListState state;
  final MovieListPresenter _movieListPresenter;
  final int _starRatingThreshold;

  MovieListController()
      : state = getIt<MovieListState>(),
        _movieListPresenter = getIt<MovieListPresenter>(),
        _starRatingThreshold = int.parse(getIt<AppParams>().param(AppParams.starRatingThreshold)),
        super();

  @override
  void initListeners() {
    _movieListPresenter.getSearchedMoviesOnNext = _receiveMovieList;
    _movieListPresenter.getSearchedMoviesOnError = _logAndShowSearchedMoviesError;

    _movieListPresenter.getMovieDetailsOnNext = _showMovieDetails;
    _movieListPresenter.getMovieDetailsOnError = _logAndShowMovieDetailsError;

    _movieListPresenter.sortMoviesOnNext = _updateMovieList;
  }

  void _logAndShowSearchedMoviesError(MovieRepositoryException e) {
    log.severe(logErrSearchMovies, e);
    _dialogErrorMovieList(e);
  }

  void _logAndShowMovieDetailsError(MovieRepositoryException e) {
    log.severe(logErrMovieDetails, e);
    _dialogErrorMovieDetails(e);
  }

  void fetchSearchedMovies(String query) {
    if (query.isEmpty) return;

    _movieListPresenter.getSearchedMovies(query);

    state.update(searchQuery: query, navCommand: NavProgressOn());
    refreshUI();
  }

  void _receiveMovieList(List<Movie>? movies) {
    if (movies == null) {
      return;
    }
    if (movies.isNotEmpty) {
      sortMovies(movies);
      return;
    }
    state.update(
      movieCardDataList: List.empty(),
      selectedMovieId: const ThreeStateInt.none(),
      scrollOffset: 0,
      navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
    );
    refreshUI();
  }

  void sortMovies(List<Movie> movies) {
    _movieListPresenter.sortMovies(movies, state.sortCriteriaList!);
  }

  Future<void> _updateMovieList(List<Movie> movies) async {
    final movieCardDataList = makeMovieCardDataList(movies);
    state.update(
      movieCardDataList: await movieCardDataList,
      selectedMovieId: const ThreeStateInt.none(),
      scrollOffset: 0,
      navCommand: NavProgressOff(),
    );
    refreshUI();
  }

  void _dialogErrorMovieList(MovieRepositoryException e) {
    state.update(
      movieCardDataList: List.empty(),
      selectedMovieId: const ThreeStateInt.none(),
      scrollOffset: 0,
      navCommand: NavErrorDialog(e),
    );
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
      navCommand: state.navCommand,
    );
  }

  Future<List<MovieCardData>> makeMovieCardDataList(List<Movie> movies) async {
    return List<MovieCardData>.generate(
      movies.length,
      (index) => _makeMovieCardData(movies, index),
    );
  }

  MovieCardData _makeMovieCardData(List<Movie> movies, int index) {
    final movie = movies[index];
    final voteAverage = (movie.voteAverage * 10).toInt();
    return MovieCardData(
      movie.id,
      movie.title,
      '$voteAverage%  ${voteAverage >= _starRatingThreshold ? "🌟" : "    "}',
    );
  }
}
