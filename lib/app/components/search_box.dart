import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_sizes.dart';
import 'package:flutter_demo/app/ui_localized_texts/txt.dart';

class SearchBox extends StatelessWidget {
  final Txt txt;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  // key string - needed for tests
  static const keySearchBox = Key('search_box');

  const SearchBox({
    required this.txt, required this.controller, required this.onSubmitted, super.key,
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
        contentPadding: const EdgeInsets.all(AppSizes.paddingInText),
        border: InputBorder.none,
        hintText: txt.get.search_prompt,
      ),
      onSubmitted: onSubmitted,
    ),
  );
}
