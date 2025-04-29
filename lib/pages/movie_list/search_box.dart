import 'package:flutter/material.dart';

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
