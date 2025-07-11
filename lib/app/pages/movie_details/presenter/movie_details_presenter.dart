import 'package:flutter_clean_architecture/flutter_clean_architecture.dart' as clean;
import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_recruitment_task/domain/usecases/get_movie_details_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/repositories/movies_repository.dart';

part 'movie_details_presenter_provider.g.dart';

// TODO use get_it to di this
abstract class MovieDetailsPresenter extends clean.Presenter {
  Function? getMovieDetailsOnNext;
  Function? getMovieDetailsOnComplete;
  Function? getMovieDetailsOnError;

  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  // TODO use get_it to di this
  MovieDetailsPresenter(DataMoviesRepository dataMoviesRepository)
      : getMovieDetailsUseCase = GetMovieDetailsUseCase(dataMoviesRepository);


  void getMovieDetails(int movieId) {
    getMovieDetailsUseCase.execute(_GetMovieDetailsUseCaseObserver(this), GetMovieDetailsUseCaseParams(movieId));
  }

  @override
  void dispose() {
    getMovieDetailsUseCase.dispose();
  }
}

class _GetMovieDetailsUseCaseObserver extends clean.Observer<GetMovieDetailsUseCaseResponse> {
  final MovieDetailsPresenter presenter;

  _GetMovieDetailsUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    presenter.getMovieDetailsOnComplete!.call();
  }

  @override
  void onError(e) {
    presenter.getMovieDetailsOnError!.call(e);
  }

  @override
  void onNext(GetMovieDetailsUseCaseResponse? response) {
    presenter.getMovieDetailsOnNext!.call();
  }

}