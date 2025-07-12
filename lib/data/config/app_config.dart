import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

@riverpod
AppConfig appConfig(Ref ref) => AppConfig();

/*
This class for all other purposes is unnecessary except it makes it possible to mock app params in tests. .
 */
class AppConfig {
  static String configFilePath = 'dotenv';
  static String recommendationProfitThreshold = 'RECOMMENDATION_PROFIT_THRESHOLD';

  String param(String paramName) => dotenv.env[paramName]!;
}
