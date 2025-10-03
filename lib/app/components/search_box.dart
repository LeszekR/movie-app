import 'package:flutter/material.dart';

import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_sizes.dart';

class SearchBox extends StatelessWidget {
  final Txt txt;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  // key string - needed for tests
  static final keySearchBox = Key('search_box');

  const SearchBox({
    super.key,
    required this.txt,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: AppSizes.textFieldHeight,
    width: AppSizes.textFieldWidth * 2,
    decoration: BoxDecoration(
      color: AppColors.textFieldBackground,
      border: Border(
        bottom: BorderSide(color: AppColors.textFieldBorder),
      ),
    ),
    child: TextField(
      key: keySearchBox,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(AppSizes.paddingInText),
        border: InputBorder.none,
        hintText: txt.get.search_prompt,
      ),
      onSubmitted: (text) => onSubmitted(text),
    ),
  );
}
