//
// import 'movie_repository_exception_ON_STRINGS.dart';
//
// enum EMovieRepositoryException {
//   movieListHttpException,
//   movieListOtherException,
//   movieDetailsHttpException,
//   movieDetailsOtherException;
//
//   static EMovieRepositoryException fromName(String eExceptionTypeName) {
//     return EMovieRepositoryException.values.firstWhere(
//           (e) => e.name == eExceptionTypeName,
//       orElse: () => throw Exception('EExceptionType found no value for: $eExceptionTypeName'),
//     );
//   }
//
//   static String nameFrom(MovieRepositoryException e) {
//     if (e is MovieListHttpException) {
//       return EMovieRepositoryException.movieDetailsHttpException.name;
//     }
//     if (e is MovieListOtherException) {
//       return EMovieRepositoryException.movieDetailsOtherException.name;
//     }
//     if (e is MovieDetailsHttpException) {
//       return EMovieRepositoryException.movieDetailsHttpException.name;
//     }
//     if (e is MovieDetailsOtherException) {
//       return EMovieRepositoryException.movieDetailsOtherException.name;
//     }
//     throw Exception('EExceptionType found no value.name for: ${e.runtimeType}');
//   }
// }
