import 'package:equatable/equatable.dart';

import 'movie_list_state.dart';

sealed class MovieListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SearchMoviesEvent extends MovieListEvent {
  final String? query;
  SearchMoviesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

final class SelectMovieEvent extends MovieListEvent {
  final int movieId;
  final double scrollOffset;
  SelectMovieEvent(this.movieId, this.scrollOffset);
  @override
  List<Object?> get props => [movieId, scrollOffset];
}

final class ShowMovieDetailsEvent extends MovieListEvent {
  final MovieId movieIdOption;
  final double scrollOffset;
  ShowMovieDetailsEvent(this.movieIdOption, this.scrollOffset);
  @override
  List<Object?> get props => [movieIdOption, scrollOffset];
}

final class ShowTwoButtonsEvent extends MovieListEvent {
  final double scrollOffset;
  ShowTwoButtonsEvent(this.scrollOffset);
  @override
  List<Object?> get props => [scrollOffset];
}
