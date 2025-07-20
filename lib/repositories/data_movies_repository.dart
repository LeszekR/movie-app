import 'dart:convert';

import 'package:http/http.dart' as http;

import '../features/movie_details/model/movie.dart';
import '../features/movie_list/model/movie_list.dart';

class MoviesRepository  {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  Future<List<Movie>> getSearchedMovies(String query) async {
    final parameters = {
      'api_key': apiKey,
      'query': query,
    };

    final endpoint = Uri.https(baseUrl, '/3/search/model', parameters);

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final movieList = MovieList.fromJson(json);
        return movieList.results;
      } else {
        throw Exception('Failed to get searched movies from web API => HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // the error will be processed in the Controller
      rethrow;
    }
  }

  @override
  Future<Movie?> getMovie(int movieId) async {
    final parameters = {
      'api_key': apiKey,
    };

    final endpoint = Uri.https(baseUrl, '/3/model/$movieId', parameters);

    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var fetchedMovie = Movie.fromJson(json);
        return fetchedMovie;
      } else {
        throw Exception('Get Movie from web API => => HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // the error will be processed in the Controller
      rethrow;
    }
  }
}
