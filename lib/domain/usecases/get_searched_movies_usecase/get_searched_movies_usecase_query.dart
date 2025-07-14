import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movies_repository.dart';

Future<List<Movie>> getSearchedMovies(MoviesRepository moviesRepository, String searchText) async {
  return await moviesRepository.getSearchedMovies(searchText);
}

class GetSearchedMoviesUseCaseParams {
  String searchText;
  GetSearchedMoviesUseCaseParams(this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movieList;
  const GetSearchedMoviesUseCaseResponse(this.movieList);
}
