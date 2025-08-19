import 'package:equatable/equatable.dart';


sealed class MovieListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class StateRestoredMoviesEvent extends MovieListEvent {}

final class SearchMoviesEvent extends MovieListEvent {
  final String? query;
  SearchMoviesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

final class SelectMovieEvent extends MovieListEvent {
  final int movieId;
  SelectMovieEvent(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

final class ShowMovieDetailsEvent extends MovieListEvent {
  final double scrollOffset;
  ShowMovieDetailsEvent(this.scrollOffset);
  @override
  List<Object?> get props => [scrollOffset];
}

final class ShowTwoButtonsEvent extends MovieListEvent {
  final double scrollOffset;
  ShowTwoButtonsEvent(this.scrollOffset);
  @override
  List<Object?> get props => [scrollOffset];
}
