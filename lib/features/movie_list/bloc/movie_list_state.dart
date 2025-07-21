import 'package:equatable/equatable.dart';

import '../../movie_details/model/movie.dart';
import '../model/movie_list.dart';

part 'movie_list_state_search_movies.dart';
part 'movie_list_state_show_details.dart';


sealed class MovieListState extends Equatable {
  const MovieListState();
  @override
  List<Object?> get props => [];
}

final class MovieSelectedState extends MovieListState {
  final int? movieId;
  const MovieSelectedState(this.movieId);
}

final class MovieListProgressState extends MovieListState {}


