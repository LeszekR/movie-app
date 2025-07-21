part of 'movie_list_state.dart';

final class MovieDetailsLoadedState extends MovieListState {
  final Movie? movie;
  const MovieDetailsLoadedState(this.movie);
}

final class MovieDetailsFetchErrorState extends MovieListState {
  final Exception e;
  const MovieDetailsFetchErrorState(this.e);
}

final class MovieDetailsNotFetchedState extends MovieListState {}
