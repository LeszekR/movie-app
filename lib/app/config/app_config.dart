import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
This class for all other purposes is unnecessary except it makes it possible to mock app params in tests. .
 */
class AppConfig {
  static String configFilePath = 'dotenv';
  static String recommendationProfitThreshold = 'RECOMMENDATION_PROFIT_THRESHOLD';
  static String starRatingThreshold = 'STAR_RATING_THRESHOLD';

  String param(String paramName) => dotenv.env[paramName]!;
}
