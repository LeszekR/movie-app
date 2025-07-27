import 'package:flutter/material.dart';
import 'package:flutter_demo/components/message_dialog.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/features/two_buttons/view/two_buttons_page.dart';

import '../common/config/app_colors.dart';
import '../common/ui_localized_texts/txt.dart';
import '../common/utils/utils.dart';
import '../features/movie_list/navigation/movie_list_navigator.dart';
import '../features/two_buttons/two_button_navigation/two_button_navigator.dart';
import '../get_it_model.dart';

class AppNavigator {
  bool _isProgressVisible = false;

  void showProgress(BuildContext context) {
    if (_isProgressVisible) return;
    _isProgressVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  void popProgress(BuildContext context) {
    if (!_isProgressVisible) return;
    _isProgressVisible = false;
    Navigator.of(context).pop();
  }

  void dialogMessage(BuildContext context, DialogParams params) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => MessageDialog(params),
    );
  }

  void dialogError(BuildContext context, Exception e) {
    dialogMessage(context, DialogParams(EButtonSet.ok, Txt.get.dialog_title_error, errorMessage(e)));
  }

  void twoButtons(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TwoButtonsPage(getit<TwoButtonNavigator>()),
      ),
    );
  }

  void movieList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MovieListView(appNavigator: getit<AppNavigator>(), moviesNavigator: getit<MovieListNavigator>()),
      ),
    );
  }
}
