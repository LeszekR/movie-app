import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/navigation/feature_navigator.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';

class TwoButtonsNavigator extends FeatureNavigator {
  TwoButtonsNavigator(super.appNavigator);

  @override
  void navigate(BuildContext context, NavigationCommand<dynamic> navCommand) {
    if (navCommand is NavMovieList) {
      appNavigator.movieList(context);
    } else {
      appNavigator.throwOnMissingNav(navCommand);
    }
  }
}
