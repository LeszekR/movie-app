
import 'package:equatable/equatable.dart';

import '../model/movie.dart';

final class MovieDetailsState extends Equatable {
  final Movie? movie;
  const MovieDetailsState({this.movie});

  @override
  List<Object?> get props => [movie];
}
