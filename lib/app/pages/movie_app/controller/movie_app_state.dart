import 'package:flutter_demo/app/config/app_config.dart';

import '../../../../bootstrap/get_it_model.dart';

enum ELanguage { pl, en }

class MovieAppState {
  String languageId;

  MovieAppState() : languageId = getIt<AppConfig>().param(AppConfig.languageOnStart);
}
