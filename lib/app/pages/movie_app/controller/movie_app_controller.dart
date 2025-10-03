import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';

class MovieAppController extends Controller {
  MovieAppState state;

  MovieAppController()
      : state = getIt<MovieAppState>(),
        super();

  @override
  void initListeners() {
    // no op
  }

  void setLanguage(ELanguage eLanguage) {
    state.languageId = eLanguage.name;
    refreshUI();
  }
}
