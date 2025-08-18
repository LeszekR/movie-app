import 'package:bloc/bloc.dart';

import '../../../../bootstrap/get_it_model.dart';
import 'movie_app_state.dart';

class MovieAppCubit extends Cubit<MovieAppState> {
  MovieAppCubit() : super(getIt<MovieAppState>());

  void setLanguage(ELanguage eLanguage) {
    emit(state.copyWith(eLanguage: eLanguage));
  }
}
