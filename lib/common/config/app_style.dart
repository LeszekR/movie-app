
import 'package:flutter/cupertino.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

class AppStyle {
  static Widget listViewSeparatorBuilder(context, index) => Container(
        height: AppSizes.separatorLineHeight,
        color: AppColors.separator,
      );
}
