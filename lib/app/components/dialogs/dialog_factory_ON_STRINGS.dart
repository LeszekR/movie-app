// import '../../../domain/repositories/movie_repository/e_movie_repository_exception.dart';
// import '../../../domain/ui_localized_texts/txt.dart';
// import '../../../get_it_model.dart';
// import 'dialog_params.dart';
// import 'e_dialog_msg.dart';
// import 'message_dialog.dart';
//
// class DialogFactory {
//   final Txt _txt;
//
//   DialogFactory() : _txt = getit<Txt>();
//
//   MessageDialog message(String eDialogMsgName) {
//     DialogParams params;
//     EDialogMessage type = EDialogMessage.from(eDialogMsgName);
//     switch (type) {
//       case EDialogMessage.searchQueryNotFound:
//         params = DialogParamsOk(_txt.get.no_searched_movies);
//       case EDialogMessage.noMovieSelected:
//         params = DialogParamsOk(_txt.get.no_movie_chosen);
//       case EDialogMessage.noSuchMovie:
//         params = DialogParamsOk(_txt.get.no_such_movie);
//     }
//     return MessageDialog(_txt, params);
//   }
//
//   MessageDialog error(String eExceptionTypeName, String errorMessage) {
//     String? text;
//     EMovieRepositoryException exceptionType = EMovieRepositoryException.fromName(eExceptionTypeName);
//     switch (exceptionType) {
//       case EMovieRepositoryException.movieListHttpException:
//         text = '${_txt.get.error_get_searched_movies}${_txt.get.error_http}$errorMessage';
//       case EMovieRepositoryException.movieListOtherException:
//         text = '${_txt.get.error_get_searched_movies}\n\n$errorMessage';
//       case EMovieRepositoryException.movieDetailsHttpException:
//         text = '${_txt.get.error_get_movie}${_txt.get.error_http}$errorMessage';
//       case EMovieRepositoryException.movieDetailsOtherException:
//         text = '${_txt.get.error_get_movie}\n\n$errorMessage';
//
//       // default protects against adding EException value and not supporting its dialog here
//       // ignore: unreachable_switch_default
//       default:
//         throw UnimplementedError('Not implemented error dialog case for: ${exceptionType.name}');
//     }
//     return MessageDialog(_txt, DialogParamsOk(text, _txt.get.dialog_title_error));
//   }
// }
