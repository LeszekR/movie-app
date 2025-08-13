import '../../../bootstrap/app_runner.dart';
import '../../repositories/movie_repository/movie_repository_exception.dart';
import 'logging_messages.dart';

class LoggingActions {
  void error(MovieRepositoryException e) {
    logger.severe('$LOG_ERR_SEARCH_MOVIES $e');
  }
}
