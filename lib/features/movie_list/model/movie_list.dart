import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../movie_details/model/movie.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList extends Equatable {
  final int totalResults;
  final List<Movie> results;

  MovieList({
    required this.totalResults,
    required this.results,
  });

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
