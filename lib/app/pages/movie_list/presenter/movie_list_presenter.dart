import 'dart:isolate';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/usecases/get_movie_details_usecase.dart';
import 'package:flutter_recruitment_task/domain/usecases/get_searched_movies_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_list_presenter_provider.g.dart';

@riverpod
MovieListPresenter movieListPresenter(Ref ref) => MovieListPresenter(ref.read(dataMoviesRepositoryProvider));

class MovieListPresenter extends Presenter {
  Function? getMovieDetailsOnComplete;
  Function? getMovieDetailsOnError;
  Function? getMovieDetailsOnNext;

  Function? getSearchedMoviesOnComplete;
  Function? getSearchedMoviesOnError;
  Function? getSearchedMoviesOnNext;

  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final GetSearchedMoviesUseCase _getSearchedMoviesUseCase;

  // TODO use get_it to di those
  MovieListPresenter(DataMoviesRepository moviesRepository)
      : _getMovieDetailsUseCase = GetMovieDetailsUseCase(moviesRepository),
        _getSearchedMoviesUseCase = GetSearchedMoviesUseCase(moviesRepository),
        super();

  @override
  void dispose() {
    _getMovieDetailsUseCase.dispose();
    _getSearchedMoviesUseCase.dispose();
  }

  void getMovieDetails(int movieId) {
    _getMovieDetailsUseCase.execute(_GetMovieDetailsObserver(this), GetMovieDetailsUseCaseParams(movieId));
  }

  void getSearchedMovies(String searchQuery) {
    _getSearchedMoviesUseCase.execute(
      _GetSearchedMoviesObserver(this),
      GetSearchedMoviesUseCaseParams(Isolate.current.controlPort, searchQuery),
    );
  }
}

class _GetMovieDetailsObserver extends Observer<GetMovieDetailsUseCaseResponse> {
  final MovieListPresenter movieListPresenter;

  _GetMovieDetailsObserver(this.movieListPresenter);

  @override
  void onNext(GetMovieDetailsUseCaseResponse? response) {
    movieListPresenter.getMovieDetailsOnNext?.call();
  }

  @override
  void onComplete() {
    movieListPresenter.getMovieDetailsOnComplete?.call();
  }

  @override
  void onError(e) {
    movieListPresenter.getMovieDetailsOnError?.call(e);
  }
}

class _GetSearchedMoviesObserver extends Observer<GetSearchedMoviesUseCaseResponse> {
  final MovieListPresenter movieListPresenter;

  _GetSearchedMoviesObserver(this.movieListPresenter);

  @override
  void onNext(GetSearchedMoviesUseCaseResponse? response) {
    movieListPresenter.getSearchedMoviesOnNext?.call();
  }

  @override
  void onComplete() {
    movieListPresenter.getSearchedMoviesOnComplete?.call();
  }

  @override
  void onError(e) {
    movieListPresenter.getSearchedMoviesOnError?.call(e);
  }
}
