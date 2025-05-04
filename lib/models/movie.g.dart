// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      title: json['title'] as String,
      id: (json['id'] as num).toInt(),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.voteAverage,
    };
