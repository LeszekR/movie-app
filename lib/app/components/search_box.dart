import 'package:flutter/material.dart';

import '../../domain/ui_localized_texts/txt.dart';
import '../../get_it_model.dart';

class SearchBox extends StatelessWidget {
  final void Function(String)? onSubmitted;

  static final keySearchBox = Key('search_box');

  const SearchBox({
    super.key,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        child: TextField(
          key: keySearchBox,
          controller: getit<SearchMoviesTextEditingController>(),
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: Txt.get.search_prompt,
          ),
          onSubmitted: onSubmitted,
        ),
      );
}

class SearchMoviesTextEditingController extends TextEditingController{}
