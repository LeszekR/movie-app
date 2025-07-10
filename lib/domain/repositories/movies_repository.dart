import '../entities/movie.dart';

abstract class MoviesRepository {
  // TODO make sure MovieList satisfies entity requirements of fca
  Future<List<Movie>> getSearchedMovies(String query);

  // TODO make sure MovieList satisfies entity requirements of fca
  Future<Movie?> getMovie(int movieId);
}
