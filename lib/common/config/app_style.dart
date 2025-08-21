import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

class AppStyle {
  static Widget movieDetailsSeparator(context, index) => Container(
    height: AppSizes.separatorLineHeight,
    color: AppColors.separator,
  );

  static const Widget listViewDivider = Divider(
    height: AppSizes.separatorLineHeight,
    thickness: 1,
    color: AppColors.separator,
  );

  static const Widget listViewSeparator = SizedBox(
    height: AppSizes.separatorLineHeight,
    child: ColoredBox(color: AppColors.separator),
  );

  static Widget horizontalSeparator() {
    return const SizedBox(width: AppSizes.separatorWidth);
  }

  static Widget horizontalSeparatorOf({double? width}) {
    return SizedBox(width: width ?? AppSizes.separatorWidth);
  }

  static Widget vertSeparator() {
    return const SizedBox(height: AppSizes.separatorHeight);
  }

  static Widget filler() {
    return Expanded(child: SizedBox());
  }
}
