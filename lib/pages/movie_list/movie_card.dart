import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String rating;

  const MovieCard({
    super.key,
    required this.title,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _onTap(context),
        child: Container(
          height: 48.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.0),
              Text(
                '$rating 🌟 ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );

  GestureTapCallback? _onTap(BuildContext context) {
  }
}
