import 'dart:async';
import 'dart:isolate';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';

class GetSearchedMoviesUseCase
    extends BackgroundUseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {
  final DataMoviesRepository moviesRepository;

  GetSearchedMoviesUseCase(this.moviesRepository);

  @override
  UseCaseTask buildUseCaseTask() {
    return _getSearchedMovies;
  }

  void _getSearchedMovies(BackgroundUseCaseParams<String> params) async {
    List<Movie> movieList = List.empty();
    try {
      var searchText = params.params;
      movieList = await moviesRepository.getSearchedMovies(searchText!);
    } catch (e) {
      // TODO create and throw exception here
      print(e);
    }
    params.port.send(GetSearchedMoviesUseCaseResponse(movieList));
  }

  /// @override
// Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
//   final StreamController<GetSearchedMoviesUseCaseResponse> streamController = StreamController();
//   try {
//     final List<Movie> movieList = await moviesRepository.getSearchedMovies(params!.searchText);
//     streamController.add(GetSearchedMoviesUseCaseResponse(movieList));
//     streamController.close();
//   } catch (e) {
//     // TODO create and throw exception here
//     print(e);
//     streamController.addError(e);
//   }
//   return streamController.stream;
// }
}

class GetSearchedMoviesUseCaseParams extends BackgroundUseCaseParams<String> {
  String searchText;

  GetSearchedMoviesUseCaseParams(super.port, this.searchText);
}

class GetSearchedMoviesUseCaseResponse {
  final List<Movie> movieList;

  const GetSearchedMoviesUseCaseResponse(this.movieList);
}

// class GetSearchedMoviesUseCaseParams {
//   final String searchText;
//
//   const GetSearchedMoviesUseCaseParams(this.searchText);
// }
