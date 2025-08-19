import 'dart:convert';

import 'package:flutter_demo/repositories/movie_repository_exception.dart';
import 'package:http/http.dart' as http;

import '../pages/movie_details/model/movie.dart';
import '../pages/movie_list/model/movie_list.dart';

class MovieRepository {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  Future<List<Movie>> getSearchedMovies(String query) async {
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
        throw MovieListHttpException(response.statusCode);
      }
    } catch (error) {
      throw MovieDetailsOtherException();
    }
  }

  Future<Movie?> getMovie(int movieId) async {
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
        throw MovieDetailsHttpException(response.statusCode);
      }
    } catch (error) {
      throw MovieListOtherException();
    }
  }
}
