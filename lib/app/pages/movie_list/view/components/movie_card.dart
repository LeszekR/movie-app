import 'package:flutter/material.dart';

import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card_data.dart';

class MovieCard extends StatelessWidget {
  final MovieCardData movieCardData;
  final void Function() onTap;
  final bool isSelected;

  const MovieCard({
    required this.movieCardData, required this.onTap, super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              movieCardData.title,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16.0),
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
            :  content,
      ),
    );
  }
}
