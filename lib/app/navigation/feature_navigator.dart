import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';

import 'app_navigator.dart';
import 'navigation_command.dart';

abstract class FeatureNavigator {
  final AppNavigator appNavigator;

  const FeatureNavigator(this.appNavigator);

  void navigate(BuildContext context, NavigationCommand navCommand);

  void go(BuildContext context, NavigationCommand? navCommand) {
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
