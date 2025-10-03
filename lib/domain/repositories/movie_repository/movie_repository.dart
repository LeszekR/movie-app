import 'package:flutter_demo/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getSearchedMovies(String query);

  Future<Movie?> getMovie(int movieId);
}
