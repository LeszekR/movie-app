import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/logger_messages.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';
import 'package:flutter_demo/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/components/three_state_value.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/pages/movie_details/model/movie.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/pages/movie_list/view/components/movie_card_data.dart';
import 'package:flutter_demo/repositories/movie_repository.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository movieRepository;
  final Sorter<Movie> sorter;
  final int _starRatingThreshold;

  MovieListBloc(AppParams appParams, this.movieRepository, this.sorter)
      : _starRatingThreshold = int.parse(appParams.param(AppParams.starRatingThreshold)),
        super(const MovieListState()) {
    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<SelectMovieEvent>(_selectMovie);
    on<ShowMovieDetailsEvent>(_fetchMovie);
    on<ShowTwoButtonsEvent>(_showTwoButtons);
    on<StateRestoredMoviesEvent>(_setStateRestored);
  }

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    final query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;

    emit(state.copyWith(navCommand: NavProgressOn()));

    try {
      List<Movie>? movies = await movieRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(
          state.copyWith(
            movieCardDataList: List.empty(),
            selectedMovieId: const ThreeStateInt.none(),
            scrollOffset: 0,
            searchQuery: query,
            navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
          ),
        );
      } else {
        movies = sorter.sortColumns(movies, state.sortCriteriaList);
        final movieCardDataList = movies == null ? null : await makeMovieCardDataList(movies);
        emit(
          state.copyWith(
            movieCardDataList: movieCardDataList,
            selectedMovieId: const ThreeStateInt.none(),
            scrollOffset: 0,
            searchQuery: query,
            navCommand: NavProgressOff(),
            restoreView: true,
          ),
        );
      }
    } on Exception catch (e) {
      log.severe(logErrSearchMovies, e);
      emit(
        state.copyWith(
          movieCardDataList: List.empty(),
          selectedMovieId: const ThreeStateInt.none(),
          scrollOffset: 0,
          searchQuery: query,
          navCommand: NavErrorDialog(e),
        ),
      );
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(selectedMovieId: ThreeStateInt.value(event.movieId)));
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    final ThreeStateInt movieId = state.selectedMovieId;
    if (!movieId.hasValue) {
      emit(
        state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
        ),
      );
      return;
    }

    emit(state.copyWith(navCommand: NavProgressOn()));

    try {
      final movie = await movieRepository.getMovie(movieId.value!);
      if (movie == null) {
        emit(
          state.copyWith(
            scrollOffset: event.scrollOffset,
            navCommand: NavMessageDialog(EDialogMsg.noSuchMovie),
          ),
        );
      } else {
        emit(
          state.copyWith(
            scrollOffset: event.scrollOffset,
            navCommand: NavMovieDetails(movie),
          ),
        );
      }
    } on Exception catch (e) {
      log.severe(logErrMovieDetails, e);
      emit(
        state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: NavErrorDialog(e),
        ),
      );
    }
  }

  Future<void> _showTwoButtons(ShowTwoButtonsEvent event, Emitter<MovieListState> emit) async {
    emit(
      state.copyWith(
        scrollOffset: event.scrollOffset,
        navCommand: NavTwoButtons(),
      ),
    );
  }

  Future<void> _setStateRestored(StateRestoredMoviesEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(restoreView: false));
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
