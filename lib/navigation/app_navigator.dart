import 'package:flutter/material.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/common/config/app_colors.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/navigation/navigation_command.dart';
import 'package:flutter_demo/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/pages/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'package:flutter_demo/pages/two_buttons/view/two_buttons_view.dart';

class AppNavigator {
  final Txt txt;
  final DialogFactory dialogFactory;

  AppNavigator(
    this.txt,
    this.dialogFactory,
    MovieListNavigator movieListNavigator,
    TwoButtonNavigator twoButtonNavigator,
  ) {
    movieListNavigator.appNavigator = this;
    twoButtonNavigator.appNavigator = this;
  }

  bool _isProgressVisible = false;

  void throwOnMissingNav(NavigationCommand<dynamic> navCommand) {
    throw UnimplementedError('No navigation implemented for NavCommand: ${navCommand.runtimeType}');
  }

  void showProgress(BuildContext context) {
    if (_isProgressVisible) return;
    _isProgressVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => const Center(child: CircularProgressIndicator()),
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
        builder: (context) => getIt<TwoButtonsView>(),
      ),
    );
  }

  void movieList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => getIt<MovieListView>(),
      ),
    );
  }
}
