// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    title: json['title'] as String,
    voteAverage: (json['vote_average'] as num).toDouble(),
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'id': instance.id,
    };
