sealed class MovieRepositoryException implements Exception {}

class MovieListHttpException extends MovieRepositoryException {
  final int statusCode;
  MovieListHttpException(this.statusCode);
}

class MovieListOtherException extends MovieRepositoryException {}

class MovieDetailsHttpException extends MovieRepositoryException {
  final int statusCode;
  MovieDetailsHttpException(this.statusCode);
}

class MovieDetailsOtherException extends MovieRepositoryException {}
