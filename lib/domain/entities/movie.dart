import '../../app/components/sorting/sortable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie implements Sortable {
  final int id;
  final String title;
  final double voteAverage;
  @JsonKey(defaultValue: 0)
  final int budget;
  @JsonKey(defaultValue: 0)
  final int revenue;

  static const String keyId = 'id';
  static const String keyTitle = 'title';
  static const String keyVoteAverage = 'vote_average';
  static const String keyBudget = 'budget';
  static const String keyRevenue = 'revenue';

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
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
