import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part  'movie_list_presenter.g.dart';

@riverpod
MovieListPresenter movieListPresenter(Ref ref) => MovieListPresenter();

class MovieListPresenter {
  // TODO refactor to flutter_clean_architecture
}