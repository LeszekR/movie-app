import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_demo/common/logging/loging_messages.dart';
import 'package:flutter_demo/components/message_dialog.dart';
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
        super(MovieListState()) {
    on<SearchMoviesEvent>(_fetchSearchedMovies);
    on<SelectMovieEvent>(_selectMovie);
    on<ShowMovieDetailsEvent>(_fetchMovie);
    on<ShowTwoButtonsEvent>(_showTwoButtons);
  }

  Future<void> _fetchSearchedMovies(SearchMoviesEvent event, Emitter<MovieListState> emit) async {
    var query = event.query;
    if (query == null) return;
    if (query.isEmpty) return;

    emit(state.copyWith(navCommand: ProgressNav()));

    try {
      List<Movie>? movies = await _moviesRepository.getSearchedMovies(event.query!);
      if (movies.isEmpty) {
        emit(state.copyWith(
          movieList: MovieList(totalResults: 0, results: []),
          scrollOffset: 0,
          selectedMovieId: const MovieId.none(),
          searchQuery: query,
          navCommand: MessageDialogNav(DialogParams(EButtonSet.ok, null, Txt.get.no_searched_movies)),
        ));
      } else {
        _sorter.sortColumns(movies, _sortCriteriaList);
        emit(state.copyWith(
          movieList: MovieList(totalResults: movies.length, results: movies),
          scrollOffset: 0,
          selectedMovieId: MovieId.none(),
          searchQuery: query,
        ));
      }
    } on Exception catch (e) {
      logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
      emit(state.copyWith(navCommand: ErrorDialogNav(e)));
    }
  }

  Future<void> _fetchMovie(ShowMovieDetailsEvent event, Emitter<MovieListState> emit) async {
    MovieId movieId = event.movieIdOption;
    if (!movieId.hasValue) {
      emit(state.copyWith(
          scrollOffset: event.scrollOffset,
          navCommand: MessageDialogNav(DialogParams(EButtonSet.ok, null, Txt.get.no_movie_chosen))));
      return;
    }

    emit(state.copyWith(navCommand: ProgressNav()));

    try {
      var movie = await getit<MoviesRepository>().getMovie(movieId.id!);
      if (movie == null) {
        emit(state.copyWith(
            scrollOffset: event.scrollOffset,
            navCommand: MessageDialogNav(DialogParams(EButtonSet.ok, null, Txt.get.no_such_movie))));
      } else {
        emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavMovieDetails(movie)));
      }
    } on Exception catch (e) {
      // TODO make logger log to console / file / service
      logger.severe('$LOG_ERR_MOVIE_DETAILS $e');
      emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: ErrorDialogNav(e)));
    }
  }

  Future<void> _selectMovie(SelectMovieEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(selectedMovieId: MovieId.of(event.movieId)));
  }

  Future<void> _showTwoButtons(ShowTwoButtonsEvent event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(scrollOffset: event.scrollOffset, navCommand: NavTwoButtons()));
  }
}
