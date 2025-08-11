import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../get_it_model.dart';
import '../components/dialogs/dialog_factory.dart';
import '../components/dialogs/e_dialog_msg.dart';
import '../config/app_colors.dart';
import '../../domain/ui_localized_texts/txt.dart';
import '../pages/movie_list/navigation/movie_list_navigator.dart';
import '../pages/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'go_router_const_strings.dart';

class AppNavigator {
  final Txt txt;
  final DialogFactory dialogFactory;
  final MovieListNavigator movieListNavigator;
  final TwoButtonNavigator twoButtonNavigator;

  AppNavigator()
      : txt = getIt<Txt>(),
        dialogFactory = getIt<DialogFactory>(),
        movieListNavigator = getIt<MovieListNavigator>(),
        twoButtonNavigator = getIt<TwoButtonNavigator>() {
    movieListNavigator.appNavigator = this;
    twoButtonNavigator.appNavigator = this;
  }

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

  void movieList(BuildContext context) {
    context.goNamed(routeHome);
  }

  void twoButtons(BuildContext context) {
    throw UnimplementedError('use GoRouter');
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => TwoButtonsView(txt, twoButtonNavigator),
    //   ),
    // );
  }
}
