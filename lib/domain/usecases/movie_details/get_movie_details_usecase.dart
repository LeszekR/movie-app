import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository.dart';
import 'package:flutter_demo/domain/utils/use_case_utils.dart';

import '../../entities/movie.dart';

class GetMovieDetailsUseCase extends UseCase<GetMovieDetailsUseCaseResponse?, GetMovieDetailsUseCaseParams> {
  final MovieRepository moviesRepository;

  // DI in constructor to satisfy dependency inversion principle with all dependencies pointing inwards -
  // if getit<DataMoviesRepository>() was used then domain would have to know about data what is forbidden in fca
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
