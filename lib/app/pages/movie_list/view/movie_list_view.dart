import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';

import '../../../../bootstrap/get_it_model.dart';
import '../../../components/buttons/button_builder.dart';
import '../../../components/search_box.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizes.dart';
import '../../../config/app_style.dart';
import '../controller/movie_list_controller.dart';
import 'components/movie_card.dart';
import 'components/movie_card_data.dart';
import 'components/movie_list_body.dart';

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

  final int _starRatingThreshold = int.parse(getIt<AppParams>().param(AppParams.starRatingThreshold));

  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: getIt<MovieListController>().state.scrollOffset);

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
      if (controller.state.navCommand != null) {
        _navigateOrRestoreState(controller, context);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(_txt.get.movie_list_title),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appBarBackground,
          actions: [
            SearchBox(
              txt: _txt,
              controller: _searchTextController,
              onSubmitted: (searchQuery) => controller.fetchSearchedMovies(searchQuery),
            ),
            AppStyle.horizontalSeparatorOf(width: AppSizes.paddingForWidget),
            IconButton(
              key: MovieListView.movieDetailsButtonKey,
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: () => controller.fetchMovie(),
            ),
            AppStyle.horizontalSeparatorOf(width: AppSizes.paddingForWidget * 5),
            SizedBox(
              height: AppSizes.textFieldHeight * 1.4,
              child: IconButton(
                key: MovieListView.languagePlButtonKey,
                icon: Image.asset('assets/icons/PL_flag.png'),
                onPressed: () => _setLanguage(controller, ELanguage.pl),
              ),
            ),
            SizedBox(
              height: AppSizes.textFieldHeight * 1.4,
              child: IconButton(
                key: MovieListView.languageEnButtonKey,
                icon: Image.asset('assets/icons/EN_flag.png'),
                onPressed: () => _setLanguage(controller, ELanguage.en),
              ),
            ),
            AppStyle.horizontalSeparatorOf(width: AppSizes.paddingForWidget),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: RepaintBoundary(
                child: MovieListBody(
                  movieList: controller.state.movieCardDataList ?? List.empty(),
                  selectedMovieId: controller.state.selectedMovieId.value,
                  scrollController: _scrollController,
                  onTap: controller.setSelectedMovieId,
                ),
              ),
            ),
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
              AppStyle.horizontalSeparator()
            ],
          ),
        ),
      );
    });
  }

  // Widget _buildMovieList(BuildContext context, MovieListController controller) {
  //   List<MovieCardData> movieList = controller.state.movieCardDataList ?? List.empty();
  //   int? selectedMovieId = controller.state.selectedMovieId.value;
  //   return RepaintBoundary(
  //     child: Scrollbar(
  //       thumbVisibility: true,
  //       controller: _scrollController,
  //       child: ListView.builder(
  //         addRepaintBoundaries: true,
  //         key: MovieListView.listViewKey,
  //         controller: _scrollController,
  //         itemCount: movieList.length * 2,
  //         itemBuilder: (context, index) {
  //           if (index.isEven) {
  //             return RepaintBoundary(
  //               child: MovieCard(
  //                 movieCardData: movieList[index ~/ 2],
  //                 onTap: controller.setSelectedMovieId,
  //                 isSelected: movieList[index ~/ 2].id == selectedMovieId,
  //               ),
  //             );
  //           } else {
  //             return AppStyle.listViewSeparator();
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  void _navigateOrRestoreState(MovieListController controller, BuildContext context) {
    if (!controller.state.navCommand!.isConsumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.state.navCommand is! NavProgressOff) _saveState(controller);
        getIt<MovieListNavigator>().go(context, controller.state.navCommand);
      });
    }
    if (controller.state.navCommand!.isConsumed || controller.state.navCommand is NavProgressOff) {
      _restoreState(controller);
    }
  }

  void _navTwoButtons(MovieListController controller) {
    controller.navTwoButtons();
  }

  void _setLanguage(MovieListController controller, ELanguage eLanguage) {
    _saveState(controller);
    getIt<MovieAppController>().setLanguage(eLanguage);
  }

  void _saveState(MovieListController controller) =>
      controller.saveState(_searchTextController.text, _scrollController.offset);

  void _restoreState(MovieListController controller) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(controller.state.scrollOffset);
    }
    _searchTextController.text = controller.state.searchQuery ?? '';
  }
}
