import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';

import 'app_params.dart';
import '../pages/movie_app/view/movie_app.dart';
import 'get_it_model.dart';


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


