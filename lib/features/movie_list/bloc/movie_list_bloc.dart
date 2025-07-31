import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/common/logging/loging_messages.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../components/dialogs/dialog_factory.dart';
import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/sorting/sorter.dart';
import '../../../main.dart';
import '../../../repositories/movies_repository.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MoviesRepository moviesRepository;
  final Sorter<Movie> sorter;

  MovieListBloc(this.moviesRepository, this.sorter) : super(MovieListState()) {
    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<SelectMovieEvent>(_selectMovie);
    on<ShowMovieDetailsEvent>(_fetchMovie);
    on<ShowTwoButtonsEvent>(_showTwoButtons);
  }

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    var query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;

    emit(state.copyWith(navCommand: NavProgress()));

    try {
      List<Movie>? movies = await moviesRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(state.copyWith(
          movieList: MovieList(totalResults: 0, results: []),
          scrollOffset: 0,
          selectedMovieId: const MovieId.none(),
          searchQuery: query,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ));
      } else {
        sorter.sortColumns(movies, _sortCriteriaList);
        emit(state.copyWith(
          movieList: MovieList(totalResults: movies.length, results: movies),
          scrollOffset: 0,
          selectedMovieId: MovieId.none(),
          searchQuery: query,
        ));
      }
    } on Exception catch (e) {
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(navCommand: NavErrorDialog(e)));
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(selectedMovieId: MovieId.value(event.movieId)));
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    MovieId movieId = event.movieIdOption;
    if (!movieId.hasValue) {
      emit(state.copyWith(
        scrollOffset: event.scrollOffset,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ));
      return;
    }

    emit(state.copyWith(navCommand: NavProgress()));

    try {
      var movie = await moviesRepository.getMovie(movieId.id!);
      if (movie == null) {
        emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavMessageDialog(EDialogMsg.noSuchMovie)));
      } else {
        emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavMovieDetails(movie)));
      }
    } on Exception catch (e) {
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(navCommand: NavErrorDialog(e)));
    }
  }

  Future<void> _showTwoButtons(ShowTwoButtonsEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavTwoButtons()));
  }
}
