import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getSearchedMovies(String query);

  Future<Movie?> getMovie(int movieId);
}
