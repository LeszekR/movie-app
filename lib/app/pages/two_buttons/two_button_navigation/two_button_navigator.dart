import 'package:flutter/cupertino.dart';

import '../../../navigation/feature_navigator.dart';
import '../../../navigation/nav_commands_common.dart';

class TwoButtonNavigator extends FeatureNavigator {

  @override
  void navigate(BuildContext context, NavigationCommand navCommand) {
    if (navCommand is NavMovieList) {
      appNavigator.movieList(context);
    }
  }
}