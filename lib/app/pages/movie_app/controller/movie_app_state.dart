import 'package:flutter_demo/bootstrap/app_params.dart';

import 'package:flutter_demo/bootstrap/get_it_model.dart';

enum ELanguage { pl, en }

class MovieAppState {
  String languageId;

  MovieAppState() : languageId = getIt<AppParams>().param(AppParams.languageOnStart);
}
