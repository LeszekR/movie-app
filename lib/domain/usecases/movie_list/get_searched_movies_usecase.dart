import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/entities/movie.dart';

import '../../../data/repositories/movie_repository/data_movie_repository.dart';
import '../../utils/use_case_utils.dart';

class GetSearchedMoviesUseCase extends UseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {
  final DataMovieRepository _movieRepository;

  // DI in constructor to satisfy dependency inversion principle with all dependencies pointing inwards -
  // if getIt<DataMovieRepository>() was used then domain would have to know about data what is forbidden in fca
  GetSearchedMoviesUseCase(this._movieRepository);

  @override
  Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
    try {
      List<Movie> movieList = await _movieRepository.getSearchedMovies(params!.searchText);
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
