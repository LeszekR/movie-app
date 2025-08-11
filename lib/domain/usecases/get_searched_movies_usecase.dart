import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/entities/movie.dart';

import '../../data/repositories/movie_repository/data_movie_repository.dart';
import '../../get_it_model.dart';
import '../utils/utils.dart';

class GetSearchedMoviesUseCase extends UseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {
  @override
  Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
    try {
      List<Movie> movieList = await getIt<DataMovieRepository>().getSearchedMovies(params!.searchText);
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
  final List<Movie> movieList;
  const GetSearchedMoviesUseCaseResponse(this.movieList);
}
