import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  Future<List<Movie>> searchMovies(String query) async {
    final parameters = {
      'api_key': apiKey,
      'query': query,
    };

    final endpoint = Uri.https(baseUrl, '/3/search/movie', parameters);

    final response = await http.get(endpoint);
    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);

    return movieList.results;
  }
}
