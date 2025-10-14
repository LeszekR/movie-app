import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_sizes.dart';

Widget movieDetailsSeparator(BuildContext context, int index) => Container(
      height: AppSizes.separatorLineHeight,
      color: AppColors.separator,
    );

class ListViewDivider extends Divider {
  const ListViewDivider()
      : super(
          height: AppSizes.separatorLineHeight,
          thickness: 1,
          color: AppColors.separator,
        );
}

class HorizontalSeparator extends SizedBox {
  const HorizontalSeparator() : super(width: AppSizes.separatorWidth);
  const HorizontalSeparator.of({required double width}) : super(width: width);
}

class VerticalSeparator extends SizedBox {
  const VerticalSeparator() : super(height: AppSizes.separatorHeight);
  const VerticalSeparator.of({required double height}) : super(height: height);
}

class Filler extends Expanded {
  const Filler() : super(child: const SizedBox());
}
