import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';
import 'package:flutter_recruitment_task/domain/usecases/get_searched_movies_usecase/get_searched_movies_usecase_query.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../utils/utils.dart';

UseCase getSearchedMoviesUseCaseFactory() {
  if (kIsWeb) return _GetSearchedMoviesUseCaseWeb();
  return _GetSearchedMoviesUseCaseAsync();
}

class _GetSearchedMoviesUseCaseWeb extends UseCase<GetSearchedMoviesUseCaseResponse?, GetSearchedMoviesUseCaseParams> {

  @override
  Future<Stream<GetSearchedMoviesUseCaseResponse?>> buildUseCaseStream(GetSearchedMoviesUseCaseParams? params) async {
    try {
      List<Movie> movieList = await getSearchedMovies(params!.searchText);
      return sendInStream(payload: GetSearchedMoviesUseCaseResponse(movieList));
    } on Exception catch (e) {
      return sendInStream(exception: e);
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
      sendToIsolate(params, GetSearchedMoviesUseCaseResponse(movieList));
    } on Exception catch (e) {
      sendToIsolate(params, e);
    }
  }
}


