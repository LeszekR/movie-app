import 'package:flutter/cupertino.dart';

class AppSizes {
  static const double dialogTopBarHeight = 30;
  static const double dialogBottomBarHeight = buttonHeight + 2 * paddingForWidget;

  static const double buttonWidth = 120;
  static const double buttonHeight = 30;
  static const double paddingForWidget = 10;
  static const double paddingInText = 7;
  static const double separatorHeight = paddingForWidget;
  static const double separatorWidth = paddingForWidget;

  static const double textFieldWidth = 250;
  static const double textFieldHeight = 30;

  static const double dialogMinWidth = 350;
  static const double _dialogMinTotalHeight = 200;
  static const double dialogContentMinHeight = _dialogMinTotalHeight - dialogBottomBarHeight;

  static const double dialogMaxWidth = 350;
  static const double _dialogMaxTotalHeight = 300;
  static const double dialogContentMaxHeight = _dialogMaxTotalHeight - dialogBottomBarHeight;

  static Widget filler() {
    return Expanded(child: SizedBox());
  }

  static Widget horizontalSeparator({double? width}) {
    return SizedBox(width: width ?? separatorWidth);
  }

  static Widget vertSeparator() {
    return SizedBox(height: separatorHeight);
  }
}
