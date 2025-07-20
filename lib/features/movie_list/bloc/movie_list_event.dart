import 'package:equatable/equatable.dart';

sealed class MovieListEvent extends Equatable {}

final class SearchMoviesEvent extends MovieListEvent {
  final String? searchQuery;
  SearchMoviesEvent(this.searchQuery);
  @override
  List<Object?> get props => [searchQuery];
}

final class SelectMovieEvent extends MovieListEvent {
  final int? movieId;
  SelectMovieEvent(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

final class ShowMovieDetailsEvent extends MovieListEvent {
  final int? movieId;
  final int scrollOffset;
  ShowMovieDetailsEvent(this.movieId, this.scrollOffset);
  @override
  List<Object?> get props => [movieId, scrollOffset];
}
