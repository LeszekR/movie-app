import '../../../domain/repositories/movie_repository/movie_repository_exception.dart';
import '../../../domain/ui_localized_texts/txt.dart';
import '../../../bootstrap/get_it_model.dart';
import 'dialog_params.dart';
import 'e_dialog_msg.dart';
import 'message_dialog.dart';

class DialogFactory {
  final Txt txt;

  DialogFactory() : txt = getIt<Txt>();

  MessageDialog message(EDialogMsg type) {
    DialogParams params;
    switch (type) {
      case EDialogMsg.searchQueryNotFound:
        params = DialogParamsOk(txt.get.no_searched_movies);
      case EDialogMsg.noMovieSelected:
        params = DialogParamsOk(txt.get.no_movie_chosen);
      case EDialogMsg.noSuchMovie:
        params = DialogParamsOk(txt.get.no_such_movie);
    }
    return MessageDialog(txt, params);
  }

  MessageDialog error(Exception e) {
    String? text;
    if (e is MovieListHttpException) {
      text = '${txt.get.error_get_searched_movies}${txt.get.error_http}${e.toString()}';
    } else if (e is MovieListOtherException) {
      text = '${txt.get.error_get_searched_movies}\n\n${e.toString()}';
    } else if (e is MovieDetailsHttpException) {
      text = '${txt.get.error_get_movie}${txt.get.error_http}${e.toString()}';
    } else if (e is MovieDetailsOtherException) {
      text = '${txt.get.error_get_movie}\n\n${e.toString()}';
    } else {
      throw UnimplementedError('Not implemented error dialog case for: ${e.runtimeType}');
    }
    return MessageDialog(txt, DialogParamsOk(text, txt.get.dialog_title_error));
  }
}

