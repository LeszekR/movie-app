import 'package:flutter/cupertino.dart';

class AppSizes {
  static const double dialogTopBarHeight = 30;
  static const double dialogBottomBarHeight = buttonHeight + 2 * padding;

  static const double buttonWidth = 120;
  static const double buttonHeight = 30;
  static const double padding = 10;
  static const double separatorHeight = padding;
  static const double separatorWidth = padding;

  static const double dialogMinWidth = 350;
  static const double _dialogMinTotalHeight = 200;
  static const double dialogContentMinHeight = _dialogMinTotalHeight - dialogBottomBarHeight;

  static const double dialogMaxWidth = 350;
  static const double _dialogMaxTotalHeight = 300;
  static const double dialogContentMaxHeight = _dialogMaxTotalHeight - dialogBottomBarHeight;

  static Widget spaceFiller() {
    return Expanded(child: SizedBox());
  }

  static Widget horizontalSeparator() {
    return SizedBox(width: separatorWidth);
  }

  static Widget vertSeparator() {
    return SizedBox(height: separatorHeight);
  }
}
