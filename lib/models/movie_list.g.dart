// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieList _$MovieListFromJson(Map<String, dynamic> json) {
  return MovieList(
    totalResults: json['total_results'] as int,
    results: (json['results'] as List<dynamic>)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MovieListToJson(MovieList instance) => <String, dynamic>{
      'total_results': instance.totalResults,
      'results': instance.results,
    };
