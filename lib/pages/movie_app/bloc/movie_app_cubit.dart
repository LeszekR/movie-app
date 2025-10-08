import 'package:bloc/bloc.dart';

import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/pages/movie_app/bloc/movie_app_state.dart';

class MovieAppCubit extends Cubit<MovieAppState> {
  MovieAppCubit() : super(getIt<MovieAppState>());

  void setLanguage(ELanguage eLanguage) {
    emit(state.copyWith(eLanguage: eLanguage));
  }
}
