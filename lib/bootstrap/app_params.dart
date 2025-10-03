import 'dart:io';

import 'package:flutter_demo/bootstrap/logger_setup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// This class for all other purposes is unnecessary except it makes it possible to mock app params in tests. .
class AppParams {
  static String configFilePath = 'dotenv';
  static String languageOnStart = 'LANGUAGE_ON_START';
  static String recommendationProfitThreshold = 'RECOMMENDATION_PROFIT_THRESHOLD';
  static String starRatingThreshold = 'STAR_RATING_THRESHOLD';

  String param(String paramName) => dotenv.env[paramName]!;
}

Future<bool> loadConfigFile() async {
  try {
    await dotenv.load(fileName: AppParams.configFilePath);
    return true;
  } on FileSystemException catch (e) {
    log.severe('Failed to load config params - file not found: ${AppParams.configFilePath}', e,);
  } catch (e, st) {
    log.severe('Failed to load config params - other error', e, st);
  }
  return false;
}
