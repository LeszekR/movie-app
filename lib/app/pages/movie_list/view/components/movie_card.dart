import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';

class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final int voteAverage;
  final void Function(int) onTap;
  final int starRatingThreshold;
  final bool isSelected;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.onTap,
    required this.starRatingThreshold,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap(id),
        child: Container(
          height: 48.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(color: isSelected ? AppColors.selectedTableRowBackground : null),
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
                makeRating(voteAverage, starRatingThreshold),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}

String makeRating(int voteAverage, int starRatingThreshold) {
  return '$voteAverage%  ${voteAverage >= starRatingThreshold ? "🌟" : "    "}';
}
