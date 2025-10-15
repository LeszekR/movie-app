import 'package:flutter/material.dart';
import 'package:flutter_demo/app/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/navigation/go_router_const_strings.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  final DialogFactory dialogFactory;

  AppNavigator(this.dialogFactory);

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
      builder: (context) => dialogFactory.message(context, dialogType),
    );
  }

  void dialogError(BuildContext context, Exception e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.dialogBarrier(),
      builder: (context) => dialogFactory.error(context, e),
    );
  }

  void movieList(BuildContext context) {
    context.goNamed(routeHome);
  }

  void twoButtons(BuildContext context) {
    context.goNamed(routeTwoButtons);
  }
}
