import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/common/logging/logging_messages.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';

import '../../../bootstrap/app_runner.dart';
import '../../../components/dialogs/e_dialog_msg.dart';
import '../../../components/sorting/sorter.dart';
import '../../../components/three_state_value.dart';
import '../../../repositories/movie_repository.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository movieRepository;
  final Sorter<Movie> sorter;

  MovieListBloc(this.movieRepository, this.sorter) : super(MovieListState()) {
    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<SelectMovieEvent>(_selectMovie);
    on<ShowMovieDetailsEvent>(_fetchMovie);
    on<ShowTwoButtonsEvent>(_showTwoButtons);
  }

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    var query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;

    emit(state.copyWith(navCommand: NavProgressOn()));

    try {
      List<Movie>? movies = await movieRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(state.copyWith(
          movieList: MovieList.empty(),
          selectedMovieId: const ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: query,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        ));
      } else {
        movies = sorter.sortColumns(movies, state.sortCriteriaList)!;
        emit(state.copyWith(
          movieList: MovieList(totalResults: movies.length, results: movies),
          selectedMovieId: const ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: query,
          navCommand: NavProgressOff(),
        ));
      }
    } on Exception catch (e) {
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(
          movieList: MovieList.empty(),
          selectedMovieId: const ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: query,
          navCommand: NavErrorDialog(e)));
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(selectedMovieId: ThreeStateInt.value(event.movieId)));
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    ThreeStateInt movieId = state.selectedMovieId;
    if (!movieId.hasValue) {
      emit(state.copyWith(
        scrollOffset: event.scrollOffset,
        navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
      ));
      return;
    }

    emit(state.copyWith(navCommand: NavProgressOn()));

    try {
      var movie = await movieRepository.getMovie(movieId.value!);
      if (movie == null) {
        emit(state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: NavMessageDialog(EDialogMsg.noSuchMovie),
        ));
      } else {
        emit(state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: NavMovieDetails(movie),
        ));
      }
    } on Exception catch (e) {
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: NavErrorDialog(e)));
    }
  }

  Future<void> _showTwoButtons(ShowTwoButtonsEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavTwoButtons()));
  }
}
