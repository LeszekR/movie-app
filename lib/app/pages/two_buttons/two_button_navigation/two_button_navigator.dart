import 'package:flutter/cupertino.dart';

import '../../../navigation/feature_navigator.dart';
import '../../../navigation/app_nav_commands.dart';
import '../../../navigation/navigation_command.dart';

class TwoButtonNavigator extends FeatureNavigator {

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is NavMovieList) {
      appNavigator.movieList(context);
    }
  }
}