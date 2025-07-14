import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/usecases/get_movie_details_usecase.dart';

import '../../../../domain/usecases/get_searched_movies_usecase.dart';
import '../../../../get_it_model.dart';

class MovieListPresenter extends Presenter {
  Function? getMovieDetailsOnNext;
  Function? getMovieDetailsOnComplete;
  Function? getMovieDetailsOnError;

  Function? getSearchedMoviesOnNext;
  Function? getSearchedMoviesOnComplete;
  Function? getSearchedMoviesOnError;

  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final UseCase _getSearchedMoviesUseCase;

  MovieListPresenter()
      : _getMovieDetailsUseCase = getit<GetMovieDetailsUseCase>(),
        _getSearchedMoviesUseCase = getit<GetSearchedMoviesUseCase>(),
        super();

  @override
  void dispose() {
    _getMovieDetailsUseCase.dispose();
    _getSearchedMoviesUseCase.dispose();
  }

  void getMovieDetails(int movieId) {
    _getMovieDetailsUseCase.execute(
      _GetMovieDetailsObserver(this),
      GetMovieDetailsUseCaseParams(movieId),
    );
  }

  void getSearchedMovies(String query) {
    _getSearchedMoviesUseCase.execute(
      _GetSearchedMoviesObserver(this),
      GetSearchedMoviesUseCaseParams(query),
    );
  }
}

class _GetMovieDetailsObserver extends Observer<GetMovieDetailsUseCaseResponse> {
  final MovieListPresenter _movieListPresenter;

  _GetMovieDetailsObserver(this._movieListPresenter);

  @override
  void onNext(GetMovieDetailsUseCaseResponse? response) {
    _movieListPresenter.getMovieDetailsOnNext?.call(response!.movie);
  }

  @override
  void onComplete() {
    _movieListPresenter.getMovieDetailsOnComplete?.call();
  }

  @override
  void onError(e) {
    _movieListPresenter.getMovieDetailsOnError?.call(e);
  }
}

class _GetSearchedMoviesObserver extends Observer<GetSearchedMoviesUseCaseResponse> {
  final MovieListPresenter _movieListPresenter;

  _GetSearchedMoviesObserver(this._movieListPresenter);

  @override
  void onNext(GetSearchedMoviesUseCaseResponse? response) {
    _movieListPresenter.getSearchedMoviesOnNext?.call(response?.movieList);
  }

  @override
  void onComplete() {
    _movieListPresenter.getSearchedMoviesOnComplete?.call();
  }

  @override
  void onError(e) {
    _movieListPresenter.getSearchedMoviesOnError?.call(e);
  }
}
