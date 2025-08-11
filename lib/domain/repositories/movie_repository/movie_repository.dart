import '../../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getSearchedMovies(String query);

  Future<Movie?> getMovie(int movieId);
}
