import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';
import 'package:flutter_recruitment_task/domain/usecases/get_searched_movies_usecase/get_searched_movies_usecase_query.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

UseCase getSearchedMoviesUseCaseFactory() {
  if (kIsWeb) return _GetSearchedMoviesUseCaseWeb();
  return _GetSearchedMoviesUseCaseAsync();
}

class _GetSearchedMoviesUseCaseWeb extends UseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {

  @override
  Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
    StreamController<GetSearchedMoviesUseCaseResponse> streamController = StreamController();
    try {
      List<Movie> movieList = await getSearchedMovies(params!.searchText);
      streamController.add(GetSearchedMoviesUseCaseResponse(movieList));
      streamController.close();
      return streamController.stream;
    } on Exception catch (e) {
      // TODO create and throw exception on the other side
      print(e);
      streamController.addError(e);
      streamController.close();
      return streamController.stream;
    }
  }
}

class _GetSearchedMoviesUseCaseAsync
    extends BackgroundUseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {

  @override
  UseCaseTask buildUseCaseTask() {
    return _getSearchedMovies;
  }

  static void _getSearchedMovies(BackgroundUseCaseParams<dynamic> params) async {
    try {
      List<Movie> movieList = await getSearchedMovies(params.params.searchText);
      params.port.send(BackgroundUseCaseMessage(data: GetSearchedMoviesUseCaseResponse(movieList)));
    } on Exception catch (e) {
      // TODO create and throw exception on the other side
      print(e);
      params.port.send(BackgroundUseCaseMessage<Exception>(data: e));
    }
  }
}
