import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/app/pages/movie_app/view/movie_app.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();

  setLogger();

  if (!await loadConfigFile()) {
    await SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(const MovieApp());
}
