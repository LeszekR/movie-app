import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/navigation/navigation_command.dart';

abstract class FeatureNavigator {
  AppNavigator? _appNavigator;

  set appNavigator(AppNavigator appNavigator) => _appNavigator = appNavigator;

  AppNavigator get appNavigator => _appNavigator!;

  void navigate(BuildContext context, NavigationCommand<dynamic> navCommand);

  void go(BuildContext context, NavigationCommand<dynamic>? navCommand) {
    if (navCommand == null) return;
    if (!navCommand.consumeOnce()) return;

    if (navCommand is NavProgressOn) {
      appNavigator.showProgress(context);
    } else if (navCommand is NavProgressOff) {
      appNavigator.popProgress(context);
    } else {
      appNavigator.popProgress(context);
      navigate(context, navCommand);
    }
  }
}
