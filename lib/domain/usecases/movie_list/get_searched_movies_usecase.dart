import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository.dart';
import 'package:flutter_demo/domain/utils/use_case_utils.dart';

class GetSearchedMoviesUseCase extends UseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {
  final MovieRepository _movieRepository;

  // DI in constructor to satisfy dependency inversion principle with all dependencies pointing inwards -
  // if getIt<DataMovieRepository>() was used then domain would have to know about data what is forbidden in fca
  GetSearchedMoviesUseCase(this._movieRepository);

  @override
  Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
    try {
      final List<Movie> movieList = await _movieRepository.getSearchedMovies(params!.searchText);
      return sendInStream(payload: GetSearchedMoviesUseCaseResponse(movieList));
    } on Exception catch (e) {
      return sendInStream(exception: e);
    }
  }
}

class GetSearchedMoviesUseCaseParams {
  String searchText;

  GetSearchedMoviesUseCaseParams(this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movies;

  const GetSearchedMoviesUseCaseResponse(this.movies);
}
