import 'package:equatable/equatable.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

// @JsonSerializable(fieldRename: FieldRename.snake)
// class MovieList {
//   final int totalResults;
//   final List<Movie> results;
//
//   MovieList({
//     required this.totalResults,
//     required this.results,
//   });
//
//   factory MovieList.fromJson(Map<String, dynamic> json) => _$MovieListFromJson(json);
//
//   Map<String, dynamic> toJson() => _$MovieListToJson(this);
// }

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList extends Equatable {
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

  @override
  List<Object?> get props => [totalResults, results];

  @override
  bool? get stringify => true;

// @override
// bool operator ==(Object other) {
//   if (identical(this, other)) return true;
//   if (other.runtimeType != runtimeType) return false;
//   if (totalResults != (other as MovieList).totalResults) return false;
//   if (!listEquals(results, other.results)) return false;
//   return true;
// }
//
// @override
// int get hashCode => Object.hash(totalResults, results);
}
