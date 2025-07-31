sealed class MoviesRepositoryException implements Exception {}

class MovieListHttpException extends MoviesRepositoryException {
  final int statusCode;
  MovieListHttpException(this.statusCode);
}

class MovieListOtherException extends MoviesRepositoryException {}

class MovieDetailsHttpException extends MoviesRepositoryException {
  final int statusCode;
  MovieDetailsHttpException(this.statusCode);
}

class MovieDetailsOtherException extends MoviesRepositoryException {}
