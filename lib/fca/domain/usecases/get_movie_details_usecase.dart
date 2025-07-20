import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../common/utils/utils.dart';
import '../../../features/movie_details/model/movie.dart';
import '../../../repositories/data_movies_repository.dart';

class GetMovieDetailsUseCase extends UseCase<GetMovieDetailsUseCaseResponse?, GetMovieDetailsUseCaseParams> {
  final DataMoviesRepository moviesRepository;

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
