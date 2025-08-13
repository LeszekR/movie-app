import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

import '../app/config/app_config.dart';
import '../app/movie_app.dart';
import 'get_it_model.dart';

final logger = Logger("MOVIE_APP_LOGGER");

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!await loadConfigFile()) {
    SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(const MovieApp());
}

Future<bool> loadConfigFile() async {
  try {
    await dotenv.load(fileName: AppConfig.configFilePath);
    return true;
  } on FileNotFoundError catch (e) {
    logger.severe("Failed to load config params - file not found: ${AppConfig.configFilePath}", e);
  } catch (e) {
    logger.severe("Failed to load config params - other error", e);
  }
  return false;
}
