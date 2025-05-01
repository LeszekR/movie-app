// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    id: json[Movie.keyId] as int,
    title: json[Movie.keyTitle] as String,
    voteAverage: (json[Movie.keyVoteAverage] as num).toDouble(),
    budget: json[Movie.keyBudget] ?? 0,
    revenue: json[Movie.keyRevenue] ?? 0,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      Movie.keyId: instance.id,
      Movie.keyTitle: instance.title,
      Movie.keyVoteAverage: instance.voteAverage,
      Movie.keyBudget: instance.budget,
      Movie.keyRevenue: instance.revenue,
    };
