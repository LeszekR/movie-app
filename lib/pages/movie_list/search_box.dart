import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_content.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  final void Function(String)? onSubmitted;

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
          controller: context.read<MovieListContent>().searchBoxTextController,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          onSubmitted: onSubmitted,
        ),
      );
}
