import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/app/components/search_box/search_text_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/ui_localized_texts/localized_texts_provider/txt.dart';

class SearchBox extends ConsumerWidget {
  final void Function(String)? onSubmitted;

  static final keySearchBox = Key('search_box');

  const SearchBox({
    super.key,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        child: TextField(
          key: keySearchBox,
          controller: ref.watch(searchBoxTextControllerProvider),
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
