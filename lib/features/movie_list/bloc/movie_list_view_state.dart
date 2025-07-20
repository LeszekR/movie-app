part of 'movie_list_bloc.dart';

sealed class MovieListViewState extends Equatable {
  const MovieListViewState();

  @override
  List<Object?> get props => [];
}

final class MovieListSearchProgress extends MovieListViewState {}

final class MovieListSearchError extends MovieListViewState {}

final class MovieListLoaded extends MovieListViewState {
  final MovieList? movieList;
  final double? scrollOffset;
  final int? selectedMovieId;
  final String? searchQuery;

  const MovieListLoaded(this.movieList, this.scrollOffset, this.selectedMovieId, this.searchQuery);

  @override
  List<Object?> get props => [movieList, scrollOffset, selectedMovieId, searchQuery];
}
