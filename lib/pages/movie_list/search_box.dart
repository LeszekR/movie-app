import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/search_text_controller.dart';
import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBox extends ConsumerWidget {
  final void Function(String)? onSubmitted;

  static const keySearchBox = Key('search_box');

  const SearchBox({
    super.key,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => DecoratedBox(
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
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            hintText: Txt.get.search_prompt,
          ),
          onSubmitted: onSubmitted,
        ),
      );
}
