import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../navigation/app_navigator.dart';

abstract class FeatureNavigator {
  final AppNavigator _appNavigator;

  const FeatureNavigator(AppNavigator appNavigator) : _appNavigator = appNavigator;

  AppNavigator get appNavigator => _appNavigator;


  void onNullCommand(BuildContext context);

  void navigate(BuildContext context, NavigationCommand navCommand);

  void go(BuildContext context, NavigationCommand? navCommand) {
    if (navCommand == null) {
      _appNavigator.popProgress(context);
    } else if (navCommand.isConsumed) {
      return;
    } else {
      navigate(context, navCommand);
    }
  }
}
