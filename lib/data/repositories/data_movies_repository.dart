import 'dart:convert';

import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movies_repository.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/movie_list.dart';
import '../../domain/repositories/movies_repository_exception.dart';

class DataMoviesRepository extends MoviesRepository {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'api.themoviedb.org';

  @override
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
      throw MovieListOtherException();
    }
  }

  @override
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
      throw MovieDetailsOtherException();
    }
  }
}
