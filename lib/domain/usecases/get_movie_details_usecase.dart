import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/domain/repositories/movies_repository.dart';

import '../entities/movie.dart';

// TODO use get_it to di this
class GetMovieDetailsUseCase extends UseCase<GetMovieDetailsUseCaseResponse?, GetMovieDetailsUseCaseParams> {

  final MoviesRepository moviesRepository;
  GetMovieDetailsUseCase (this.moviesRepository);

  @override
  Future <Stream<GetMovieDetailsUseCaseResponse?>> buildUseCaseStream(GetMovieDetailsUseCaseParams? params) async {
    final StreamController<GetMovieDetailsUseCaseResponse> streamController= StreamController();
    try {
      final Movie? movie = await moviesRepository.getMovie(params!.movieId);
      streamController.add(GetMovieDetailsUseCaseResponse (movie));
      streamController.close();
    } catch (e) {
      // TODO create and throw exception here
      print(e);
      streamController.addError(e);
    }
    return streamController.stream;
  }
}

class GetMovieDetailsUseCaseResponse{
  final Movie? movie;
  const GetMovieDetailsUseCaseResponse(this.movie);
}

class GetMovieDetailsUseCaseParams {
  final int movieId;
  const GetMovieDetailsUseCaseParams(this.movieId);
}