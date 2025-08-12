import 'package:flutter/material.dart';

import '../../domain/ui_localized_texts/txt.dart';
import '../../get_it_model.dart';

class SearchBox extends StatelessWidget {
  static final keySearchBox = Key('search_box');

  final Txt _txt;
  final TextEditingController textEditingController;
  final void Function(String) onSubmitted;

  SearchBox({
    super.key,
    required this.textEditingController,
    required this.onSubmitted,
  }) : _txt = getIt<Txt>();

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
          controller: textEditingController,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: _txt.get.search_prompt,
          ),
          onSubmitted: onSubmitted,
        ),
      );
}

class SearchMoviesTextEditingController extends TextEditingController{}
