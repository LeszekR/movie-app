import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository_exception.dart';

typedef GetMovieDetailsOnNext = void Function(Movie?);
typedef GetMovieDetailsOnComplete = void Function();
typedef GetMovieDetailsOnError = void Function(MovieRepositoryException);

typedef GetSearchedMoviesOnNext = void Function(List<Movie>);
typedef GetSearchedMoviesOnComplete = void Function();
typedef GetSearchedMoviesOnError = void Function(MovieRepositoryException);

typedef SortMoviesOnNext = void Function(List<Movie>);
typedef SortMoviesOnComplete = void Function();
typedef SortMoviesOnError = void Function(MovieRepositoryException);
