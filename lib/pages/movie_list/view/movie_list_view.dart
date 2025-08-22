import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';
import 'package:flutter_demo/pages/movie_app/bloc/movie_app_cubit.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/pages/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/pages/movie_list/navigation/movie_list_navigator.dart';

import '../../../common/config/app_colors.dart';
import '../../../common/config/app_style.dart';
import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/search_box.dart';
import '../../movie_app/bloc/movie_app_state.dart';
import '../bloc/movie_list_bloc.dart';
import 'components/movie_card.dart';

class MovieListView extends StatefulWidget {
  static const movieDetailsButtonKey = Key('movieDetailsButtonKey');
  static const languagePlButtonKey = Key('languagePlButtonKey');
  static const languageEnButtonKey = Key('languageEnButtonKey');
  static const twoButButtonKey = Key("twoButtonsButtonKey");
  static const listViewKey = ValueKey('movieListKey');

  final Txt txt;
  final MovieListNavigator moviesNavigator;

  const MovieListView({
    super.key,
    required this.txt,
    required this.moviesNavigator,
  });

  @override
  State<StatefulWidget> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  MovieAppCubit get _appCubit => context.read<MovieAppCubit>();

  MovieListBloc get _bloc => context.read<MovieListBloc>();
  TextEditingController? _searchTextController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreViewState();
    });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    _searchTextController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieListBloc, MovieListState>(
      listenWhen: (previous, current) => previous.navCommand != current.navCommand,
      listener: (context, state) => widget.moviesNavigator.go(context, state.navCommand),
      builder: (context, state) {
        if (state.restoreView) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _restoreViewState();
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.txt.get.movie_list_title),
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.appBarBackground,
            actions: [
              SearchBox(
                txt: widget.txt,
                controller: _searchTextController!,
                onSubmitted: (searchQuery) => _fetchSearchedMovies(searchQuery),
              ),
              AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget),
              IconButton(
                key: MovieListView.movieDetailsButtonKey,
                icon: Icon(Icons.movie_creation_outlined),
                onPressed: () => _showMovieDetails(state),
              ),
              // AppSizes.filler(),
              AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget * 5),
              SizedBox(
                height: AppSizes.textFieldHeight * 1.4,
                child: IconButton(
                  key: MovieListView.languagePlButtonKey,
                  icon: Image.asset('assets/icons/PL_flag.png'),
                  onPressed: () => _setAppLanguage(ELanguage.pl),
                ),
              ),
              // AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget / 4),
              SizedBox(
                height: AppSizes.textFieldHeight * 1.4,
                child: IconButton(
                  key: MovieListView.languageEnButtonKey,
                  icon: Image.asset('assets/icons/EN_flag.png'),
                  onPressed: () => _setAppLanguage(ELanguage.en),
                ),
              ),
              // AppSizes.filler(),
              AppSizes.horizontalSeparator(width: AppSizes.paddingForWidget),
            ],
          ),
          body: RepaintBoundary(
            child: Column(
              children: <Widget>[
                Expanded(child: _buildMovieList(context, state)),
              ],
            ),
          ),
          bottomNavigationBar: Container(
              height: AppSizes.dialogBottomBarHeight,
              color: AppColors.appBarBackground,
              child: Row(
                children: [
                  Expanded(child: const SizedBox()),
                  ButtonBuilder(context)
                      .onTap(_showTwoButtons)
                      .key(MovieListView.twoButButtonKey)
                      .text(widget.txt.get.goto_two_buttons)
                      .width(AppSizes.navButtonWidth)
                      .build(),
                  AppSizes.horizontalSeparator()
                ],
              )),
        );
      },
    );
  }

  Widget _buildMovieList(BuildContext context, MovieListState state) {
    int? selectedMovieId = state.selectedMovieId.value;
    var movieList = state.movieCardDataList ?? List.empty();

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        key: MovieListView.listViewKey,
        controller: _scrollController,
        itemCount: movieList.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            var movieCardData = movieList[index ~/ 2];
            return MovieCard(
              movieCardData: movieCardData,
              onTap: () => _bloc.add(SelectMovieEvent(movieCardData.id)),
              isSelected: movieCardData.id == selectedMovieId,
            );
          } else {
            return AppStyle.listViewDivider;
          }
        },
      ),
    );
  }

  void _setAppLanguage(ELanguage eLanguage) {
    _appCubit.setLanguage(eLanguage);
  }

  void _fetchSearchedMovies(String? searchQuery) => _bloc.add(SearchMoviesEvent(searchQuery));

  void _showMovieDetails(MovieListState state) => _bloc.add(ShowMovieDetailsEvent(_scrollController!.offset));

  void _showTwoButtons(BuildContext context) => _bloc.add(ShowTwoButtonsEvent(_scrollController!.offset));

  void _restoreViewState() {
    _bloc.add(StateRestoredMoviesEvent());
    var state = _bloc.state;
    _scrollController!.jumpTo(state.scrollOffset);
    _searchTextController!.text = state.searchQuery ?? '';
  }
}
