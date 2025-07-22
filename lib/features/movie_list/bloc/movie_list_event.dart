import 'package:equatable/equatable.dart';

sealed class MovieListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ShowProgressEvent extends MovieListEvent {}

final class ShowMovieDetailsEvent extends MovieListEvent {
  final int? movieId;
  ShowMovieDetailsEvent(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

final class SearchMoviesEvent extends MovieListEvent {
  final String? query;
  SearchMoviesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

final class SelectMovieEvent extends MovieListEvent {
  final int? movieId;
  final int scrollOffset;
  SelectMovieEvent(this.movieId, this.scrollOffset);
  @override
  List<Object?> get props => [movieId, scrollOffset];
}
