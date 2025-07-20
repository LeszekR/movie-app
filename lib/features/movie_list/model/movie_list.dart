import 'package:json_annotation/json_annotation.dart';

import '../../movie_details/model/movie.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList {
  final int totalResults;
  final List<Movie> results;

  MovieList({
    required this.totalResults,
    required this.results,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) => _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);
}
