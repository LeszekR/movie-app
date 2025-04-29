import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Movie implements Sortable{
  final String title;
  final double voteAverage;
  final int id;

  Movie({
    required this.title,
    required this.voteAverage,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  List getSortableFields() {
    return [title, voteAverage];
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
