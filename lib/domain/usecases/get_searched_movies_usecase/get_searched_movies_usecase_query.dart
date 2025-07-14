import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';
import 'package:flutter_recruitment_task/get_it_model.dart';

Future<List<Movie>> getSearchedMovies(String searchText) async {
  return await getit<DataMoviesRepository>().getSearchedMovies(searchText);
}

class GetSearchedMoviesUseCaseParams {
  String searchText;
  GetSearchedMoviesUseCaseParams(this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movieList;
  const GetSearchedMoviesUseCaseResponse(this.movieList);
}
