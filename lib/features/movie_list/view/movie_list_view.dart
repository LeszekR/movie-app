import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';

import '../../../common/config/app_colors.dart';
import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/search_box.dart';
import '../../../common/config/app_style.dart';
import '../../../navigation/app_navigator.dart';
import '../../movie_details/model/movie.dart';
import '../bloc/movie_list_bloc.dart';
import 'components/movie_card.dart';

class MovieListView extends StatefulWidget {
  static var movieDetailsButtonKey = Key('movieDetailsButtonKey');
  static var twoButButtonKey = Key("twoButtonsButtonKey");
  static var listViewKey = ValueKey('movieListKey');
  final Txt txt;
  final AppNavigator appNavigator;
  final MovieListNavigator moviesNavigator;

  const MovieListView({
    super.key,
    required this.txt,
    required this.appNavigator,
    required this.moviesNavigator,
  });

  @override
  State<StatefulWidget> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  MovieListBloc get _bloc => context.read<MovieListBloc>();
  TextEditingController? _searchTextController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = _bloc.state;
      _scrollController!.jumpTo(state.scrollOffset);
      _searchTextController!.text = state.searchQuery ?? '';
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
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(child: _buildMovieList(context, state)),
            ],
          ),
          bottomNavigationBar: Container(
              height: AppSizes.dialogBottomBarHeight,
              color: AppColors.appBarBackground,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  ButtonBuilder(context)
                      .onTap(_showTwoButtons)
                      .key(MovieListView.twoButButtonKey)
                      .text(widget.txt.get.goto_two_buttons)
                      .width(200)
                      .build(),
                  AppSizes.horizontalSeparator()
                ],
              )),
        );
      },
    );
  }

  Widget _buildMovieList(BuildContext context, MovieListState state) {
    List<Movie> movieList = state.movieList?.results ?? List.empty();
    int? selectedMovieId = state.selectedMovieId.id;
    return ListView.separated(
      key: MovieListView.listViewKey,
      controller: _scrollController,
      separatorBuilder: AppStyle.listViewSeparatorBuilder,
      itemBuilder: (context, index) => MovieCard(
        id: movieList[index].id,
        title: movieList[index].title,
        voteAverage: movieList[index].voteAverage,
        isSelected: movieList[index].id == selectedMovieId,
        onTap: (_) => _bloc.add(SelectMovieEvent(movieList[index].id)),
      ),
      itemCount: movieList.length,
    );
  }

  void _fetchSearchedMovies(String? searchQuery) => _bloc.add(SearchMoviesEvent(searchQuery));

  void _showMovieDetails(MovieListState state) => _bloc.add(ShowMovieDetailsEvent(_scrollController!.offset));

  void _showTwoButtons(BuildContext context) => _bloc.add(ShowTwoButtonsEvent(_scrollController!.offset));
}
