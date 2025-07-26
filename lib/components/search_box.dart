import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';

import '../common/ui_localized_texts/txt.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  // key string - needed for tests
  static final keySearchBox = Key('search_box');

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: AppSizes.textFieldHeight,
        width: AppSizes.textFieldWidth,
        // padding: EdgeInsets.only(left: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
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
            // prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: Txt.get.search_prompt,
          ),
          onSubmitted: (text) => onSubmitted(text),
        ),
      );
}
