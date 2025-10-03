import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter_callbacks.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository_exception.dart';
import 'package:flutter_demo/domain/services/sorting/sort_criteria.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/sort_movies_use_case.dart';

class MovieListPresenter extends Presenter {
  GetMovieDetailsOnNext? getMovieDetailsOnNext;
  GetMovieDetailsOnComplete? getMovieDetailsOnComplete;
  GetMovieDetailsOnError? getMovieDetailsOnError;

  GetSearchedMoviesOnNext? getSearchedMoviesOnNext;
  GetSearchedMoviesOnComplete? getSearchedMoviesOnComplete;
  GetSearchedMoviesOnError? getSearchedMoviesOnError;

  SortMoviesOnNext? sortMoviesOnNext;
  SortMoviesOnComplete? sortMoviesOnComplete;
  SortMoviesOnError? sortMoviesOnError;

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
      SortMoviesUseCaseParams(movies, sortCriteriaList),
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
  void onError(dynamic e) {
    _presenter.getMovieDetailsOnError?.call(e as MovieRepositoryException);
  }
}

class _GetSearchedMoviesObserver extends Observer<GetSearchedMoviesUseCaseResponse> {
  final MovieListPresenter _movieListPresenter;

  _GetSearchedMoviesObserver(this._movieListPresenter);

  @override
  void onNext(GetSearchedMoviesUseCaseResponse? response) {
    if (response == null) return;
    _movieListPresenter.getSearchedMoviesOnNext?.call(response.movies);
  }

  @override
  void onComplete() {
    _movieListPresenter.getSearchedMoviesOnComplete?.call();
  }

  @override
  void onError(dynamic e) {
    _movieListPresenter.getSearchedMoviesOnError?.call(e as MovieRepositoryException);
  }
}

class _SortMoviesObserver extends Observer<SortMoviesUseCaseResponse> {
  final MovieListPresenter _movieListPresenter;

  _SortMoviesObserver(this._movieListPresenter);

  @override
  void onNext(SortMoviesUseCaseResponse? response) {
    if (response == null) return;
    _movieListPresenter.sortMoviesOnNext?.call(response.movies);
  }

  @override
  void onComplete() {
    _movieListPresenter.sortMoviesOnComplete?.call();
  }

  @override
  void onError(dynamic e) {
    _movieListPresenter.sortMoviesOnError?.call(e as MovieRepositoryException);
  }
}
