import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_colors.dart';

import '../../../../common/config/app_config.dart';
import '../../../../bootstrap/get_it_model.dart';

class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final double voteAverage;
  final void Function(int) onTap;
  final bool isSelected;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(id),
        child: Container(
          height: 48.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(color: isSelected ?  AppColors.selectedTableRowBackground : null),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.0),
              Text(
                makeRating(voteAverage),
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,
              ),
            ],
          ),
        ),
      );
  }
}

String makeRating(double voteAverage) =>
    '${(voteAverage * 10).toInt()}%  '
        '${(voteAverage * 10).toInt() >= int.parse(getIt<AppConfig>().param(AppConfig.starRatingThreshold)) ? "🌟" : "    "}';
