import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/view/movie_app.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();

  setLogger();

  // catch unhandled errors other than framework errors (those will be logged by the framework)
  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(null, error, stack);
    return true;
  };

  if (!await loadConfigFile()) {
    await SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(MovieApp(getIt<MovieAppController>()));
}
