import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';

import '../../../../bootstrap/get_it_model.dart';
import '../../../components/buttons/button_builder.dart';
import '../../../components/search_box.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizes.dart';
import '../../../config/app_style.dart';
import '../controller/movie_list_controller.dart';
import 'components/movie_card.dart';

class MovieListView extends CleanView {
  static var movieDetailsButtonKey = Key('movieDetailsButtonKey');
  static var twoButButtonKey = Key("twoButtonsButtonKey");
  static var listViewKey = ValueKey('movieListKey');

  const MovieListView({super.key});

  @override
  MovieListViewState createState() => MovieListViewState();
}

class MovieListViewState extends CleanViewState<MovieListView, MovieListController> {
  final Txt _txt;

  MovieListViewState()
      : _txt = getIt<Txt>(),
        super(getIt<MovieListController>());

  // name must vary from _controller which is CleanViewState field and will get shadowed if it is used here

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieListController>(builder: (context, controller) {
      if (controller.state.navCommand != controller.state.prevNavCommand) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getIt<MovieListNavigator>().go(context, controller.state.navCommand);
          controller.restoreView = true;
        });
      }
      // TODO finish this properly - either keep the whole controllers or restore state here
      // else if (controller.restoreView) {
      //   controller.restoreView = false;
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     // controller.restoreViewState();
      //   });
      // }
      return Scaffold(
        appBar: AppBar(
          title: Text(_txt.get.movie_list_title),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarBackground,
          actions: [
            SearchBox(
              txt: _txt,
              controller: controller.searchTextController,
              onSubmitted: (searchQuery) => controller.fetchSearchedMovies(searchQuery),
            ),
            AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget),
            IconButton(
              key: MovieListView.movieDetailsButtonKey,
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: () => controller.fetchMovie(),
            ),
            // AppSizes.filler(),
            AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget * 5),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildMovieList(context, controller)),
          ],
        ),
        bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            color: AppColors.appBarBackground,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                ButtonBuilder()
                    .onTap(() => getIt<AppNavigator>().twoButtons(context))
                    .key(MovieListView.twoButButtonKey)
                    .text(_txt.get.goto_two_buttons)
                    .width(AppSizes.navButtonWidth)
                    .build(),
                AppSizes.horizontalSeparator()
              ],
            )),
      );
    });
  }

  Widget _buildMovieList(BuildContext context, MovieListController controller) {
    List<Movie> movieList = controller.state.movieList?.results ?? List.empty();
    int? selectedMovieId = controller.state.selectedMovieId.id;
    return ListView.separated(
      key: MovieListView.listViewKey,
      controller: controller.scrollController,
      separatorBuilder: AppStyle.listViewSeparatorBuilder,
      itemBuilder: (context, index) => MovieCard(
        id: movieList[index].id,
        title: movieList[index].title,
        voteAverage: movieList[index].voteAverage,
        isSelected: movieList[index].id == selectedMovieId,
        onTap: controller.setSelectedMovieId,
      ),
      itemCount: movieList.length,
    );
  }
}
