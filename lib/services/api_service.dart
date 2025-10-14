import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:flutter_recruitment_task/services/movie_service_exception.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@riverpod
ApiService apiService(Ref ref) => ApiService();

class ApiService {
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
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final movieList = MovieList.fromJson(json);
        return movieList.results;
      } else {
        throw MovieListHttpException(response.statusCode);
      }
    } catch (e) {
      throw MovieListOtherException();
    }
  }

  Future<Movie?> movie(int movieId) async {
    final parameters = {
      'api_key': apiKey,
    };

    final endpoint = Uri.https(baseUrl, '/3/movie/$movieId', parameters);

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final fetchedMovie = Movie.fromJson(json);
        return fetchedMovie;
      } else {
        throw MovieDetailsHttpException(response.statusCode);
      }
    } catch (e) {
      throw MovieDetailsOtherException();
    }
  }
}
