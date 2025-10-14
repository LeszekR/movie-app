import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/components/buttons/button_builder.dart';
import 'package:flutter_demo/app/components/search_box.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_sizes.dart';
import 'package:flutter_demo/app/config/app_style.dart';
import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_state.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';

class MovieListView extends CleanView {
  static Key movieDetailsButtonKey = const Key('movieDetailsButtonKey');
  static Key languagePlButtonKey = const Key('languagePlButtonKey');
  static Key languageEnButtonKey = const Key('languageEnButtonKey');
  static Key twoButButtonKey = const Key('twoButtonsButtonKey');
  static ValueKey<String> listViewKey = const ValueKey('movieListKey');

  const MovieListView({super.key});

  @override
  MovieListViewState createState() => MovieListViewState();
}

class MovieListViewState extends CleanViewState<MovieListView, MovieListController> {
  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: getIt<MovieListState>().scrollOffset);

  MovieListViewState() : super(getIt<MovieListController>());

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieListController>(
      builder: (context, controller) {
        final localizations = AppLocalizations.of(context);
        if (controller.state.navCommand != null) {
          _navigateOrRestoreState(controller, context);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations!.movie_list_title),
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.appBarBackground,
            actions: [
              SearchBox(
                controller: _searchTextController,
                onSubmitted: (searchQuery) => controller.fetchSearchedMovies(searchQuery),
              ),
              AppStyle.horizontalSeparatorOf(width: AppSizes.paddingForWidget),
              IconButton(
                key: MovieListView.movieDetailsButtonKey,
                icon: const Icon(Icons.movie_creation_outlined),
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
          body: RepaintBoundary(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _buildMovieList(context, controller),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            color: AppColors.appBarBackground,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                ButtonBuilder(context)
                    .onTap((context) => _navTwoButtons(controller))
                    .key(MovieListView.twoButButtonKey)
                    .text(localizations.goto_two_buttons)
                    .width(AppSizes.navButtonWidth)
                    .build(),
                AppStyle.horizontalSeparator(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieList(BuildContext context, MovieListController controller) {
    final movieList = controller.state.movieCardDataList ?? List.empty();

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        key: MovieListView.listViewKey,
        controller: _scrollController,
        itemCount: movieList.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            final movieData = movieList[index ~/ 2];
            return MovieCard(
              movieCardData: movieData,
              onTap: () => controller.setSelectedMovieId(movieData.id),
              isSelected: movieData.id == controller.state.selectedMovieId.value,
            );
          } else {
            return AppStyle.listViewDivider;
          }
        },
      ),
    );
  }

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
