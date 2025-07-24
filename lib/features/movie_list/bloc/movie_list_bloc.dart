import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';

import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/sorting/sorter.dart';
import '../../../get_it_model.dart';
import '../../../main.dart';
import '../../../repositories/data_movies_repository.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MoviesRepository _moviesRepository;
  final Sorter<Movie> _sorter;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Movie? movieToShow;

  MovieListBloc({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository,
        _sorter = Sorter<Movie>(),
        super(MovieListState(
          movieList: null,
          scrollOffset: null,
          searchQuery: null,
          selectedMovieId: null,
        )) {
    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<SelectMovieEvent>(_selectMovie);
    on<ShowMovieDetailsEvent>(_fetchMovie);
  }

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    var query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;
    if (event.query == state.searchQuery) return;

    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 1)); // only to present the progress indicator

    try {
      List<Movie>? movies = await _moviesRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(state.copyWith(
          movieList: MovieList(totalResults: 0, results: []),
          scrollOffset: 0,
          selectedMovieId: null,
          searchQuery: query,
        ));
        // TODO show dialog "no movies found"
      } else {
        _sorter.sortColumns(movies, _sortCriteriaList);
        emit(state.copyWith(
          movieList: MovieList(totalResults: movies.length, results: movies),
          scrollOffset: 0,
          selectedMovieId: null,
          searchQuery: query,
        ));
      }
    } on Exception catch (e) {

      logger.severe('Failed to get searched movies from web API => error: $e');
      emit(state.copyWith(error: e));
      // TODO show the user error dialog with error details
    }
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    var movieId = event.movieId;
    if (movieId == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      var movie = await getit<MoviesRepository>().getMovie(movieId);
      emit(state.copyWith(movie: movie));
      emit(state.copyWith()); // restore state with movie = null to stop navigating to MovieDetails on nav back
      //
    } on Exception catch (e) {
      // TODO show the user error dialog with error details in the listener
      logger.severe('Failed to get selected movie from web API => error: $e');
      emit(state.copyWith(error: e));
      // TODO show the user error dialog with error details
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(scrollOffset: event.scrollOffset, selectedMovieId: event.movieId));
  }

// void setSelectedMovieId(int movieId) {
//   state.selectedMovieId = movieId;
//   refreshUI();
// }
//
// int? getSelectedMovieId() {
//   return state.selectedMovieId;
// }
//
// void fetchMovie() {
//   var selectedMovieId = state.selectedMovieId;
//   if (selectedMovieId == null) return;
//   _movieListPresenter.getMovieDetails(selectedMovieId);
// }
//
// void showMovieDetails(Movie? movie) {
//   movieToShow = movie;
//   if (movie == null) return;
//   refreshUI();
// }
//
// void onMovieDetailsShown() {
//   movieToShow = null;
// }
//
// void saveViewState() {
//   state.query = searchTextController.text;
//   state.scrollOffset = scrollController.offset;
// }
//
// void restoreViewState() {
//   _restoreScroll();
//   _restoreSearchQuery();
// }
//
// void _restoreScroll() {
//   double? scrollOffset = state.scrollOffset;
//   if (scrollOffset == null) return;
//   scrollController.jumpTo(scrollOffset);
// }
//
// void _restoreSearchQuery() {
//   searchTextController.text = state.query ?? '';
// }
}
