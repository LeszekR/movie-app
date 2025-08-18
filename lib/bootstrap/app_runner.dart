import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../app/pages/movie_app/view/movie_app.dart';
import 'app_params.dart';
import 'get_it_model.dart';
import 'logger_setup.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();

  setLogger();

  if (!await loadConfigFile()) {
    SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(const MovieApp());
}
