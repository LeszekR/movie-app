import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie implements Sortable{
  final int id;
  final String title;
  final double voteAverage;
  final int budget;
  final int revenue;

  static String keyId = 'id';
  static String keyTitle = 'title';
  static String keyVoteAverage = 'vote_average';
  static String keyBudget = 'budget';
  static String keyRevenue = 'revenue';

  Movie({
    required this.title,
    required this.voteAverage,
    required this.id,
    required this.budget,
    required this.revenue,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  Map<String, dynamic> getSortableFieldsMap() {
    return {keyTitle: title, keyVoteAverage: voteAverage};
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
