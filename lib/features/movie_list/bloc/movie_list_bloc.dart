import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';

import '../../../common/utils/utils.dart';
import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/sorting/sorter.dart';
import '../../../get_it_model.dart';
import '../../../main.dart';
import '../../../repositories/data_movies_repository.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';
import '../../../components/search_box.dart';
import '../view/movie_list_view.dart';
import 'package:equatable/equatable.dart';
import '../model/movie_list.dart';
import 'movie_list_state.dart';


class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MoviesRepository _moviesRepository;
  final ScrollController scrollController;
  final TextEditingController searchTextController;
  final Sorter<Movie> _sorter;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Movie? movieToShow;

  MovieListBloc({required MoviesRepository moviesRepository})
      : scrollController = getit<MovieListScrollController>(),
        searchTextController = getit<SearchMoviesTextEditingController>(),
        _sorter = Sorter<Movie>(),
        _moviesRepository = moviesRepository,
        super(MovieListLoadedState(null, null, null, null)) {

    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<ShowMovieDetailsEvent>(_fetchMovie);
    on<SelectMovieEvent>(_selectMovie);
  }

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    var query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;

    emit(MovieListProgressState());
    // TODO show progress widget here

    var movies = await _getSearchedMovies(query);
    if (movies == null) emit(MovieListEmptyState());
    // TODO show dialog "no movies found"

    _sorter.sortColumns(movies!.results, _sortCriteriaList);
    emit((state as MovieListLoadedState).copyWith(movieList: movies));
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    var movieId = event.movieId;
    if (movieId == null) return;

    emit(MovieListProgressState());
    // TODO show progress widget here

    var movie = await _getSelectedMovie(movieId);

    if (movie == null) emit(MovieDetailsNotFetchedState());
    // TODO if not error but not found - show the user dialog "movie not found"

    emit(MovieDetailsLoadedState(movie));
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(MovieSelectedState(event.movieId));
  }

  void setSelectedMovieId(int movieId) {
    state.selectedMovieId = movieId;
    refreshUI();
  }

  int? getSelectedMovieId() {
    return state.selectedMovieId;
  }

  void fetchMovie() {
    var selectedMovieId = state.selectedMovieId;
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
    state.query = searchTextController.text;
    state.scrollOffset = scrollController.offset;
  }

  void restoreViewState() {
    _restoreScroll();
    _restoreSearchQuery();
  }

  void _restoreScroll() {
    double? scrollOffset = state.scrollOffset;
    if (scrollOffset == null) return;
    scrollController.jumpTo(scrollOffset);
  }

  void _restoreSearchQuery() {
    searchTextController.text = state.query ?? '';
  }

  Future<MovieList?> _getSearchedMovies(String searchText) async {
    try {
      List<Movie>? movieList = await getit<MoviesRepository>().getSearchedMovies(searchText);
      return MovieList(totalResults: movieList.length, results: movieList);
    } on Exception catch (e) {
      // TODO show the user error dialog with error details
      logger.severe('Failed to get searched movies from web API => error: $e');
      return null;
    }
  }

  Future<Movie?> _getSelectedMovie(int movieId) async {
    try {
      return  await getit<MoviesRepository>().getMovie(movieId);
    } on Exception catch (e) {
      // TODO show the user error dialog with error details
      logger.severe('Failed to get selected movie from web API => error: $e');
      return  null;
    }
  }
}
