import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/navigation/feature_navigator.dart';
import 'package:flutter_demo/navigation/navigation_command.dart';

class TwoButtonNavigator extends FeatureNavigator {

  @override
  void navigate(BuildContext context, NavigationCommand<dynamic> navCommand) {
    if (navCommand is NavMovieList) {
      appNavigator.movieList(context);
    } else {
      appNavigator.throwOnMissingNav(navCommand);
    }
  }
}
