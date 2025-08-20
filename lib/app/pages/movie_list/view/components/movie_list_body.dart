import 'package:flutter/material.dart';

import '../../../../config/app_style.dart';
import 'movie_card.dart';
import 'movie_card_data.dart';

class MovieListBody extends StatelessWidget {
  final List<MovieCardData> movieList;
  final int? selectedMovieId;
  final ScrollController scrollController;
  final void Function(int) onTap;

  const MovieListBody({
    required this.movieList,
    required this.selectedMovieId,
    required this.scrollController,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: movieList.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            var movieData = movieList[index ~/ 2];
            return MovieCard(
              key: ValueKey(movieData.id),
              movieCardData: movieData,
              onTap: onTap,
              isSelected: movieData.id == selectedMovieId,
            );
          } else {
            return AppStyle.listViewDivider;
            // return AppStyle.listViewSeparator;
          }
        },
      ),
    );
  }
}
