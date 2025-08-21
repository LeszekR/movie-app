import 'package:flutter/material.dart';

import '../../../../common/config/app_colors.dart';
import 'movie_card_data.dart';

class MovieCard extends StatelessWidget {
  final MovieCardData movieCardData;
  final void Function() onTap;
  final bool isSelected;

  const MovieCard({
    super.key,
    required this.movieCardData,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              movieCardData.title,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16.0),
          Text(
            movieCardData.rating,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48.0,
        child: isSelected
            ? ColoredBox(
                color: AppColors.selectedTableRowBackground,
                child: content,
              )
            : content,
      ),
    );
  }
}
