import 'package:flutter/cupertino.dart';

import '../../../navigation/app_navigator.dart';
import 'navigation_command.dart';

abstract class FeatureNavigator {
  AppNavigator? _appNavigator;
  set appNavigator(AppNavigator appNavigator) => _appNavigator = appNavigator;
  AppNavigator get appNavigator => _appNavigator!;

  void navigate(BuildContext context, NavigationCommand navCommand);

  void go(BuildContext context, NavigationCommand? navCommand) {
    if (navCommand == null) {
      _appNavigator!.popProgress(context);
    } else if (!navCommand.consumeOnce()) {
      return;
    } else {
      navigate(context, navCommand);
    }
  }
}
