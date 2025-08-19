import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/services/sorting/sort_criteria.dart';
import 'package:flutter_demo/domain/utils/use_case_utils.dart';

import '../../entities/movie.dart';
import '../../services/sorting/sorter.dart';

class SortMoviesUseCase extends UseCase<SortMoviesUseCaseResponse, SortMoviesUseCaseParams> {
  final Sorter<Movie> _sorter;
  SortMoviesUseCase(this._sorter);

  @override
  Future<Stream<SortMoviesUseCaseResponse?>> buildUseCaseStream(SortMoviesUseCaseParams? params) {
    _sorter.sortColumns(params!.movies, params.sortCriteriaList);
    return Future.value(sendInStream(payload: SortMoviesUseCaseResponse(params.movies)));
  }
}

class SortMoviesUseCaseResponse {
  final List<Movie> movies;
  const SortMoviesUseCaseResponse(this.movies);
}

class SortMoviesUseCaseParams {
  final List<Movie> movies;
  final List<SortCriteria> sortCriteriaList;
  const SortMoviesUseCaseParams(this.movies, this.sortCriteriaList);
}