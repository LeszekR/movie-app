import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
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
  static var languagePlButtonKey = Key('languagePlButtonKey');
  static var languageEnButtonKey = Key('languageEnButtonKey');
  static var twoButButtonKey = Key("twoButtonsButtonKey");
  static var listViewKey = ValueKey('movieListKey');

  const MovieListView({super.key});

  @override
  MovieListViewState createState() => MovieListViewState();
}

class MovieListViewState extends CleanViewState<MovieListView, MovieListController> {
  final Txt _txt;
  final ScrollController _scrollController = getIt<ScrollController>();
  final TextEditingController _searchTextController = getIt<TextEditingController>();
  final int _starRatingThreshold = int.parse(getIt<AppParams>().param(AppParams.starRatingThreshold));

  MovieListViewState()
      : _txt = getIt<Txt>(),
        super(getIt<MovieListController>());

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieListController>(builder: (context, controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.state.navCommand != null && !controller.state.navCommand!.isConsumed) {
          _navigate(context, controller);
        } else if (controller.state.restoreView) {
          _restoreViewState(controller);
        }
      });
      return Scaffold(
        appBar: AppBar(
          title: Text(_txt.get.movie_list_title),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarBackground,
          actions: [
            Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) _saveState(controller);
              },
              child: SearchBox(
                txt: _txt,
                controller: _searchTextController,
                onSubmitted: (searchQuery) => controller.fetchSearchedMovies(searchQuery),
              ),
            ),
            AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget),
            IconButton(
              key: MovieListView.movieDetailsButtonKey,
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: () => controller.fetchMovie(),
            ),
            AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget * 5),
            SizedBox(
              height: AppSizes.textFieldHeight * 1.4,
              child: IconButton(
                key: MovieListView.languagePlButtonKey,
                icon: Image.asset('assets/icons/PL_flag.png'),
                onPressed: () => _setLanguage(controller, ELanguage.pl),
              ),
            ),
            // AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget / 4),
            SizedBox(
              height: AppSizes.textFieldHeight * 1.4,
              child: IconButton(
                key: MovieListView.languageEnButtonKey,
                icon: Image.asset('assets/icons/EN_flag.png'),
                onPressed: () => _setLanguage(controller, ELanguage.en),
              ),
            ),
            // AppSizes.filler(),
            AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildMovieList(context, controller, _starRatingThreshold)),
          ],
        ),
        bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            color: AppColors.appBarBackground,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                ButtonBuilder(context)
                    .onTap((context) => _navTwoButtons(controller))
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

  Widget _buildMovieList(BuildContext context, MovieListController controller, int starRatingThreshold) {
    List<Movie> movieList = controller.state.movieList?.results ?? List.empty();
    int? selectedMovieId = controller.state.selectedMovieId.value;
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        key: MovieListView.listViewKey,
        controller: _scrollController,
        itemBuilder: (context, index) => RepaintBoundary(
          child: Column(
            children: [
              MovieCard(
                id: movieList[index].id,
                title: movieList[index].title,
                voteAverage: (movieList[index].voteAverage * 10).toInt(),
                starRatingThreshold: starRatingThreshold,
                isSelected: movieList[index].id == selectedMovieId,
                onTap: controller.setSelectedMovieId,
              ),
              AppStyle.listViewSeparatorBuilder(context, index),
            ],
          ),
        ),
        itemCount: movieList.length,
      ),
    );
  }

  void _navTwoButtons(MovieListController controller) {
    controller.navTwoButtons();
  }

  void _navigate(BuildContext context, MovieListController controller) {
    _saveState(controller);
    getIt<MovieListNavigator>().go(context, controller.state.navCommand);
  }

  void _setLanguage(MovieListController controller, ELanguage eLanguage) {
    if (controller.state.navCommand is! NavProgressOff) _saveState(controller);
    getIt<MovieAppController>().setLanguage(eLanguage);
  }

  void _saveState(MovieListController controller) =>
      controller.saveState(_searchTextController.text, _scrollController.offset);

  void _restoreViewState(MovieListController controller) {
    var offset = controller.state.scrollOffset;
    _scrollController.jumpTo(offset);

    _searchTextController.text = controller.state.searchQuery ?? '';

    controller.setViewRestored();
  }
}
