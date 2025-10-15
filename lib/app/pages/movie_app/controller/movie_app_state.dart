import 'package:flutter_demo/bootstrap/app_params.dart';

enum ELanguage { pl, en }

class MovieAppState {
  String languageId;

  MovieAppState(AppParams appParams) : languageId = appParams.param(AppParams.languageOnStart);
}
