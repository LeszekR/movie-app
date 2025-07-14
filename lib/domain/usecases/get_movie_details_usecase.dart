import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/repositories/movies_repository.dart';
import 'package:flutter_demo/domain/utils/utils.dart';

import '../entities/movie.dart';

class GetMovieDetailsUseCase extends UseCase<GetMovieDetailsUseCaseResponse?, GetMovieDetailsUseCaseParams> {
  final MoviesRepository moviesRepository;

  GetMovieDetailsUseCase(this.moviesRepository);

  @override
  Future<Stream<GetMovieDetailsUseCaseResponse?>> buildUseCaseStream(GetMovieDetailsUseCaseParams? params) async {
    try {
      final Movie? movie = await moviesRepository.getMovie(params!.movieId);
      return sendInStream(payload: GetMovieDetailsUseCaseResponse(movie));
    } on Exception catch (e) {
      return sendInStream(exception: e);
    }
  }
}

class GetMovieDetailsUseCaseResponse {
  final Movie? movie;
  const GetMovieDetailsUseCaseResponse(this.movie);
}

class GetMovieDetailsUseCaseParams {
  final int movieId;
  const GetMovieDetailsUseCaseParams(this.movieId);
}
