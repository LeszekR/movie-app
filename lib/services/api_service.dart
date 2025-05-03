import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@riverpod
class ApiService extends _$ApiService {
  @override
  ApiService build() => ApiService();

  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  Future<List<Movie>> searchMovies(String query) async {
    final parameters = {
      'api_key': apiKey,
      'query': query,
    };

    final endpoint = Uri.https(baseUrl, '/3/search/movie', parameters);

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final movieList = MovieList.fromJson(json);
        return movieList.results;
      } else {
        // TODO Throw a custom exception - for known HTTP error codes
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // TODO Throw a custom exception - for network errors, JSON parsing errors, etc.
      print('Exception during movie fetch: $error');
    }
    return Future.value([]);
  }


  Future<Movie?> movie(int movieId) async {
    final parameters = {
      'api_key': apiKey,
    };

    final endpoint = Uri.https(baseUrl, '/3/movie/$movieId', parameters);

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var fetchedMovie = Movie.fromJson(json);
        return fetchedMovie;
      } else {
        // TODO Throw a custom exception - for known HTTP error codes
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // TODO Throw a custom exception - for network errors, JSON parsing errors, etc.
      print('Exception during movie fetch: $error');
    }
    return null;
  }
}
