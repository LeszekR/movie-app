import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';

import '../../../common/utils/utils.dart';
import '../../../components/sorting/e_sort_direction.dart';
import '../../../components/sorting/sort_criteria.dart';
import '../../../components/sorting/sorter.dart';
import '../../../get_it_model.dart';
import '../../../repositories/data_movies_repository.dart';
import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';
import '../../../components/search_box.dart';
import '../view/movie_list_view.dart';
import 'package:equatable/equatable.dart';
import '../model/movie_list.dart';

part 'movie_list_view_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListViewState> {
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
        super(MovieListSearchProgress());

  @override
  void initListeners() {
    _movieListPresenter.getSearchedMoviesOnNext = (movieList) => updateMovieList(movieList);
    _movieListPresenter.getSearchedMoviesOnError = (e) {
      // TODO show error dialog to the user
      logger.severe("Error - failed to fetch movies from web API", e);
    };
    _movieListPresenter.getMovieDetailsOnNext = (movie) => showMovieDetails(movie);
    _movieListPresenter.getMovieDetailsOnError = (e) {
      // TODO show error dialog to the user
      logger.severe("Error - failed to fetch model details from web API", e);
    };
  }

  void fetchSearchedMovies(String query) async {
    if (query.isEmpty) return;
    state.movieList = await _getSearchedMovies(query);
  }

  void updateMovieList(List<Movie> movies) {
    _sorter.sortColumns(movies, _sortCriteriaList);
    state.movieList = MovieList(totalResults: movies.length, results: movies);
    refreshUI();
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
    state.searchQuery = searchTextController.text;
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
    searchTextController.text = state.searchQuery ?? '';
  }

  Future<MovieList?> _getSearchedMovies(String searchText) async {
    try {
      List<Movie>? movieList = await getit<MoviesRepository>().getSearchedMovies(searchText);
      return MovieList(totalResults: movieList.length, results: movieList);
    } on Exception catch (e) {
      logger.severe('Failed to get searched movies from web API => error: $e');
      return null;
    }
  }

  Future<Stream<Movie?>> buildUseCaseStream(int movieId) async {
    try {
      final Movie? movie = await getit<MoviesRepository>().getMovie(movieId);
      return sendInStream(payload: movie);
    } on Exception catch (e) {
      return sendInStream(exception: e);
    }
  }
}
