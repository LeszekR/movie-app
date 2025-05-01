import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie implements Sortable{
  final String title;
  final double voteAverage;
  final int id;

  final int budget;
  final int revenue;

  static String keyTitle = 'title';
  static String keyVoteAverage = 'voteAverage';

  Movie({
    required this.title,
    required this.voteAverage,
    required this.id,
    this.budget = 0,
    this.revenue = 0,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  Map<String, dynamic> getSortableFields() {
    return {keyTitle: title, keyVoteAverage: voteAverage};
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
