import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_details_presenter_provider.g.dart';

@riverpod
MovieDetailsPresenter movieDetailsPresenter(Ref ref) => MovieDetailsPresenter();

class MovieDetailsPresenter {
  // TODO refactor to flutter_clean_architecture
}