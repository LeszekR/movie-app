import 'package:logging/logging.dart';

final log = Logger("MOVIE_APP_LOGGER");

void setLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}: ${record.error}');
  });
  Logger.root.level = Level.WARNING;
}
