import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList {
  final int totalResults;
  final List<Movie> results;

  const MovieList({
    required this.totalResults,
    required this.results,
  });

  const MovieList.empty() :
        totalResults = 0,
        results = const [];

  factory MovieList.fromJson(Map<String, dynamic> json) => _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);
}
