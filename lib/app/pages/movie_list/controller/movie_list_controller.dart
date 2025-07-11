import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/app/pages/movie_list/controller/state/movie_list_state_controller.dart';
import 'package:flutter_recruitment_task/app/pages/movie_list/presenter/movie_list_presenter.dart';

import '../../../../data/repositories/data_movies_repository.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_list.dart';
import '../../../utils/sorting/e_sort_direction.dart';
import '../../../utils/sorting/sort_criteria.dart';
import '../../../utils/sorting/sorter.dart';


class MovieListController extends Controller {
  final MovieListPresenter _movieListPresenter;
  final MovieListStateController? stateController;
  final ScrollController scrollController;
  final TextEditingController searchTextController;
  final Sorter<Movie> _sorter;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Movie? movieToShow;

  // TODO use get_it to di this
  MovieListController()
      : _movieListPresenter = MovieListPresenter(DataMoviesRepository()),
        stateController = MovieListStateController(),
        scrollController = ScrollController(),
        searchTextController = TextEditingController(),
        _sorter = Sorter<Movie>(),
        super();

  @override
  void initListeners() {
    _movieListPresenter.getSearchedMoviesOnNext = (movieList) => updateMovieList(movieList);
    _movieListPresenter.getSearchedMoviesOnError = (e) {
      // TODO show error dialog to the user
      // TODO log error
    };
    _movieListPresenter.getMovieDetailsOnNext = (movie) => showMovieDetails(movie);
    _movieListPresenter.getMovieDetailsOnError = (e) {
      // TODO show error dialog to the user
      // TODO log error
    };
  }

  void fetchSearchedMovies(String query) {
    if (query.isEmpty) return;
    _movieListPresenter.getSearchedMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    _sorter.sortColumns(movies, _sortCriteriaList);
    stateController!.setMovieList(MovieList(totalResults: movies.length, results: movies));
    refreshUI();
  }

  void fetchMovie() {
    var selectedMovieId = stateController!.getSelectedMovieId();
    if (selectedMovieId == null) return;
    _movieListPresenter.getMovieDetails(selectedMovieId);
  }

  void showMovieDetails(Movie? movie) {
    movieToShow = movie;
    if (movie == null) return;
    refreshUI();
  }

  void onMovieDetailsShown() {
    movieToShow = null;
  }

  void saveViewState() {
    stateController!.setSearchQuery(searchTextController.text);
    stateController!.setScrollOffset(scrollController.offset);
  }

  void restoreViewState() {
    _restoreScroll();
    _restoreSearchQuery();
  }

  void _restoreScroll() {
    double? lastScrollOffset = stateController!.getScrollOffset();
    if (lastScrollOffset == null) return;
    scrollController.jumpTo(lastScrollOffset);
  }

  void _restoreSearchQuery() {
    searchTextController.text = stateController!.getSearchQuery() ?? '';
  }
}
