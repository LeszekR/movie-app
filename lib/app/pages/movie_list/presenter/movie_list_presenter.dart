import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/services/sorting/sort_criteria.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';

import '../../../../bootstrap/get_it_model.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/movie_list/get_searched_movies_usecase.dart';
import '../../../../domain/usecases/movie_list/sort_movies_use_case.dart';

class MovieListPresenter extends Presenter {
  Function? getMovieDetailsOnNext;
  Function? getMovieDetailsOnComplete;
  Function? getMovieDetailsOnError;

  Function? getSearchedMoviesOnNext;
  Function? getSearchedMoviesOnComplete;
  Function? getSearchedMoviesOnError;

  Function? sortMoviesOnNext;
  Function? sortMoviesOnComplete;
  Function? sortMoviesOnError;

  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final GetSearchedMoviesUseCase _getSearchedMoviesUseCase;
  final SortMoviesUseCase _sortMoviesUseCase;

  MovieListPresenter()
      : _getMovieDetailsUseCase = getIt<GetMovieDetailsUseCase>(),
        _getSearchedMoviesUseCase = getIt<GetSearchedMoviesUseCase>(),
        _sortMoviesUseCase = getIt<SortMoviesUseCase>(),
        super();

  @override
  void dispose() {
    _getMovieDetailsUseCase.dispose();
    _getSearchedMoviesUseCase.dispose();
    _sortMoviesUseCase.dispose();
  }

  void getSearchedMovies(String query) {
    _getSearchedMoviesUseCase.execute(
      _GetSearchedMoviesObserver(this),
      GetSearchedMoviesUseCaseParams(query),
    );
  }

  void getMovieDetails(int movieId) {
    _getMovieDetailsUseCase.execute(
      _GetMovieDetailsObserver(this),
      GetMovieDetailsUseCaseParams(movieId),
    );
  }
  
  void sortMovies(List<Movie> movies, List<SortCriteria> sortCriteriaList) {
    _sortMoviesUseCase.execute(
      _SortMoviesObserver(this),
      SortMoviesUseCaseParams(movies,sortCriteriaList),
    );
  }
}

class _GetMovieDetailsObserver extends Observer<GetMovieDetailsUseCaseResponse> {
  final MovieListPresenter _presenter;

  _GetMovieDetailsObserver(this._presenter);

  @override
  void onNext(GetMovieDetailsUseCaseResponse? response) {
    _presenter.getMovieDetailsOnNext?.call(response!.movie);
  }

  @override
  void onComplete() {
    _presenter.getMovieDetailsOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.getMovieDetailsOnError?.call(e);
  }
}

class _GetSearchedMoviesObserver extends Observer<GetSearchedMoviesUseCaseResponse> {
  final MovieListPresenter _movieListPresenter;

  _GetSearchedMoviesObserver(this._movieListPresenter);

  @override
  void onNext(GetSearchedMoviesUseCaseResponse? response) {
    _movieListPresenter.getSearchedMoviesOnNext?.call(response?.movies);
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

class _SortMoviesObserver extends Observer<SortMoviesUseCaseResponse>{
  final MovieListPresenter _movieListPresenter;

  _SortMoviesObserver(this._movieListPresenter);

  @override
  void onNext(SortMoviesUseCaseResponse? response) {
    _movieListPresenter.sortMoviesOnNext?.call(response?.movies);
  }

  @override
  void onComplete() {
    _movieListPresenter.sortMoviesOnComplete?.call();
  }

  @override
  void onError(e) {
    _movieListPresenter.sortMoviesOnError?.call(e);
  }
}