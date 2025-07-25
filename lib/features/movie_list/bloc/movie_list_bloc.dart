import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/common/logging/loging_messages.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../common/ui_localized_texts/txt.dart';
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

    emit(state.copyWith(navCommand: ShowLoading()));
    // await Future.delayed(Duration(seconds: 1)); // only to present the progress indicator

    try {
      List<Movie>? movies = await _moviesRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(state.copyWith(
          movieList: MovieList(totalResults: 0, results: []),
          scrollOffset: 0,
          selectedMovieId: null,
          searchQuery: query,
        ));
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
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(navCommand: ShowError(e)));
    }
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    var movieId = event.movieId;
    if (movieId == null) return;

    emit(state.copyWith(navCommand: ShowLoading()));

    try {
      var movie = await getit<MoviesRepository>().getMovie(movieId);
      if (movie == null ){
        emit(state.copyWith(navCommand: ShowDialog(Txt.get.no_such_movie)));
      } else {
        emit(state.copyWith(navCommand: ShowMovieDetails(movie)));
      }
      emit(state.copyWith()); // restore state with navCommand = null to stop navigating to MovieDetails on nav back
      //
    } on Exception catch (e) {
      // TODO make logger log to console / file / service
      logger.severe('$LOG_ERR_MOVIE_DETAILS $e');
      emit(state.copyWith(navCommand: ShowError(e)));
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(scrollOffset: event.scrollOffset, selectedMovieId: event.movieId));
  }
}
