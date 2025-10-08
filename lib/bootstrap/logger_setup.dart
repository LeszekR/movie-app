import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final log = Logger('MOVIE_APP_LOGGER');

void setLogger() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  Logger.root.onRecord.listen((record) {
    final errorText = record.error != null ? ' ERROR: ${record.error}' : '';
    final msg =
        '${record.level.name.padRight(7)} | ${record.time.toIso8601String()} | ${record.loggerName} | ${record.message}$errorText';
    debugPrint(msg);
  });
}
