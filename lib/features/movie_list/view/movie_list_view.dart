import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/movie_list_navigator.dart';

import '../../../common/ui_localized_texts/txt.dart';
import '../../../components/search_box.dart';
import '../../movie_details/model/movie.dart';
import '../bloc/movie_list_bloc.dart';
import 'components/movie_card.dart';

class MovieListView extends StatefulWidget {
  final MovieListNavigator _navigator;

  const MovieListView({super.key, required MovieListNavigator navigator}) : _navigator = navigator;

  @override
  State<StatefulWidget> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  MovieListBloc get _bloc => context.read<MovieListBloc>();
  ScrollController? _scrollController;
  TextEditingController? _searchTextController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = _bloc.state;
      _scrollController!.jumpTo(state.scrollOffset ?? 0);
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
      listenWhen: (previous, current) {
        return previous.isLoading != current.isLoading;
      },
      listener: (context, state) {
        widget._navigator.nav(state, context);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Txt.get.movie_list_title),
            actions: [
              IconButton(
                icon: Icon(Icons.movie_creation_outlined),
                onPressed: () => _showMovieDetails(context, state),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              SearchBox(
                controller: _searchTextController!,
                onSubmitted: (searchQuery) => _fetchSearchedMovies(context, searchQuery),
              ),
              Expanded(child: _buildMovieList(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMovieList(BuildContext context, MovieListState state) {
    List<Movie> movieList = state.movieList?.results ?? List.empty();
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) => MovieCard(
        id: movieList[index].id,
        title: movieList[index].title,
        rating: '${(movieList[index].voteAverage * 10).toInt()}%',
        isSelected: movieList[index].id == state.selectedMovieId,
        onTap: (_) => _bloc.add(SelectMovieEvent(movieList[index].id, _scrollController!.offset)),
      ),
      itemCount: movieList.length,
    );
  }

  void _showMovieDetails(BuildContext context, MovieListState state) =>
      _bloc.add(ShowMovieDetailsEvent(state.selectedMovieId));

  void _fetchSearchedMovies(BuildContext context, String? searchQuery) => _bloc.add(SearchMoviesEvent(searchQuery));

}
