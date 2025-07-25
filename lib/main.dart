import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/get_it_model.dart';
import 'package:flutter_demo/movie_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

import 'common/config/app_config.dart';
import 'common/logging/loging_messages.dart';

final logger = Logger("MOVIE_APP_LOGGER");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!await loadConfigFile()) {
    SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(
    const MovieApp(),
  );
}

Future<bool> loadConfigFile() async {
  try {
    await dotenv.load(fileName: AppConfig.configFilePath);
    return true;
  } on FileNotFoundError catch (e) {
    logger.severe('$LOG_ERR_CONFIG_FILE_NOT_FOUND ${AppConfig.configFilePath}', e);
  } catch (e) {
    logger.severe(LOG_ERR_LOADING_OTHER, e);
  }
  return false;
}
