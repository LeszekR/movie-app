import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../components/sorting/sortable.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie extends Equatable implements Sortable {
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

  const Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.budget,
    required this.revenue,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  Map<String, dynamic> getSortableFieldsMap() {
    return {keyTitle: title, keyVoteAverage: voteAverage};
  }

  @override
  List<Object?> get props => [id, title, voteAverage, budget, revenue];

  @override
  bool? get stringify => true;
}
