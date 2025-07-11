import 'dart:convert';

import 'package:flutter_recruitment_task/domain/entities/movie.dart';
import 'package:flutter_recruitment_task/domain/repositories/movies_repository.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/movie_list.dart';

part 'data_movies_repository_provider.g.dart';

@riverpod
// TODO make sure it will be a singleton
DataMoviesRepository apiService(Ref ref) => DataMoviesRepository();

// TODO refactor to flutter_clean_architecture
class  DataMoviesRepository extends MoviesRepository {

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
        // TODO Throw a custom exception - for known HTTP error codes
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // TODO Throw a custom exception - for network errors, JSON parsing errors, etc.
      print('Exception during movie fetch: $error');
    }
    return Future.value([]);
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
