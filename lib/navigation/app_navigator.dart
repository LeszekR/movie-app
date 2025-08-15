import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/features/two_buttons/view/two_buttons_view.dart';

import '../common/config/app_colors.dart';
import '../common/ui_localized_texts/txt.dart';
import '../components/dialogs/dialog_factory.dart';
import '../components/dialogs/e_dialog_msg.dart';
import '../features/movie_list/navigation/movie_list_navigator.dart';
import '../features/two_buttons/two_button_navigation/two_button_navigator.dart';
import '../bootstrap/get_it_model.dart';
import 'navigation_command.dart';

class AppNavigator {
  final Txt txt;
  final DialogFactory dialogFactory;
  final MovieListNavigator movieListNavigator;
  final TwoButtonNavigator twoButtonNavigator;

  AppNavigator(
    this.txt,
    this.dialogFactory,
    this.movieListNavigator,
    this.twoButtonNavigator,
  ) {
    movieListNavigator.appNavigator = this;
    twoButtonNavigator.appNavigator = this;
  }

  bool _isProgressVisible = false;

  void throwOnMissingNav(NavigationCommand navCommand){
    throw UnimplementedError('No navigation implemented for NavCommand: ${navCommand.runtimeType}');
  }

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
    if (!Navigator.of(context).canPop()) return;
    _isProgressVisible = false;
    Navigator.of(context).pop();
  }

  void dialogMessage(BuildContext context, EDialogMsg dialogType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => dialogFactory.message(dialogType),
    );
  }

  void dialogError(BuildContext context, Exception e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => dialogFactory.error(e),
    );
  }

  void twoButtons(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TwoButtonsView(txt, twoButtonNavigator),
      ),
    );
  }

  void movieList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieListView(
          txt: txt,
          appNavigator: this,
          moviesNavigator: movieListNavigator,
          scrollController: getit<MovieListScrollController>(),
        ),
      ),
    );
  }
}
