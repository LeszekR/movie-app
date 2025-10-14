import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/components/dialogs/dialog_params.dart';
import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/components/dialogs/message_dialog.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/domain/repositories/movie_repository/movie_repository_exception.dart';

class DialogFactory {
  const DialogFactory();

  MessageDialog message(BuildContext context, EDialogMsg type) {
    final localizations = AppLocalizations.of(context)!;
    DialogParams params;
    switch (type) {
      case EDialogMsg.searchQueryNotFound:
        params = DialogParamsOk(localizations.no_searched_movies);
      case EDialogMsg.noMovieSelected:
        params = DialogParamsOk(localizations.no_movie_chosen);
      case EDialogMsg.noSuchMovie:
        params = DialogParamsOk(localizations.no_such_movie);
    }
    return MessageDialog(params);
  }

  MessageDialog error(BuildContext context, Exception e) {
    final localizations = AppLocalizations.of(context)!;
    String? text;
    if (e is MovieListHttpException) {
      text = '${localizations.error_get_searched_movies}${localizations.error_http}${e.statusCode}';
    } else if (e is MovieListOtherException) {
      text = '${localizations.error_get_searched_movies}${localizations.error_other}';
    } else if (e is MovieDetailsHttpException) {
      text = '${localizations.error_get_movie}${localizations.error_http}${e.statusCode}';
    } else if (e is MovieDetailsOtherException) {
      text = '${localizations.error_get_movie}${localizations.error_other}';
    } else {
      throw UnimplementedError('Not implemented error dialog case for: ${e.runtimeType}');
    }
    return MessageDialog(DialogParamsOk(text, localizations.dialog_title_error));
  }
}
