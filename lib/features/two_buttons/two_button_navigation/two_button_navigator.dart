import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';

import '../../../navigation/feature_navigator.dart';

class TwoButtonNavigator extends FeatureNavigator {

  @override
  void onNullCommand(BuildContext context) {}

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is MovieListNav) {
      appNavigator.movieList(context);
    }
  }
}