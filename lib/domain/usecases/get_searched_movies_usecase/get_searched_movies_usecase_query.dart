import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';

// TODO use get_it to di this
// TODO and refactor to non-static for mocking in tests
Future<List<Movie>> getSearchedMovies(String searchText) async {
  return await DataMoviesRepository().getSearchedMovies(searchText);
}

class GetSearchedMoviesUseCaseParams {
  String searchText;

  GetSearchedMoviesUseCaseParams(this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movieList;

  const GetSearchedMoviesUseCaseResponse(this.movieList);
}
