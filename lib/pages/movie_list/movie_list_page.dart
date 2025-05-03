import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/providers/movie_list_scroll.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/movie_list_state.dart';
import '../../utils/routing/go_router_const_strings.dart';
import 'movie_list_manager.dart';

class MovieListPage extends ConsumerStatefulWidget {
  const MovieListPage({super.key});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends ConsumerState<MovieListPage> {
  MovieListState? _movieListState;
  MovieListManager? _movieListPageManager;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState;
    _movieListState = ref.watch(movieListStateProvider.notifier);
    _movieListPageManager = ref.read(movieListManagerProvider);
    _scrollController = ref.read(movieListScrollControllerProvider);

    _scrollController?.addListener(() {
      _movieListState!.setScrollOffset(_scrollController!.offset);
    });
    _movieListPageManager!.restoreScroll();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: _onOpenMovieDetailsTap,
            ),
          ],
          title: Text('Movie Browser'),
        ),
        body: Column(
          children: <Widget>[
            SearchBox(onSubmitted: _onSearchBoxSubmitted),
            Expanded(child: _buildMoviesList(_movieListState!.getMovieList().results)),
          ],
        ),
      );

  Widget _buildMoviesList(List<Movie> movies) => ListView.separated(
        // controller: _scrollController,
        separatorBuilder: (context, index) => Container(
          height: 1.0,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) => MovieCard(
          id: movies[index].id,
          title: movies[index].title,
          rating: '${(movies[index].voteAverage * 10).toInt()}%',
          onTap: _onMovieTap,
          isSelected: movies[index].id == _movieListState!.getSelectedMovieId(),
        ),
        itemCount: movies.length,
      );

  void _onSearchBoxSubmitted(String? query) async {
    if (query == null) return;

    var fetchedMovieList = await _movieListPageManager!.fetchMovieList(query);
    if (fetchedMovieList == null) return;

    if (!mounted) return;
    _movieListPageManager!.updateMovieList(fetchedMovieList);
  }

  void _onOpenMovieDetailsTap() async {
    if (_movieListState!.getSelectedMovieId() == null) return;

    var fetchedMovie = await _movieListPageManager!.fetchMovie(_movieListState!.getSelectedMovieId()!);
    if (fetchedMovie == null) return;

    if (!mounted) return;

    context.goNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: fetchedMovie.title.toString(),
        paramMovieBudget: fetchedMovie.budget.toString(),
        paramMovieRevenue: fetchedMovie.revenue.toString(),
      },
    );
  }

  void _onMovieTap(int movieId) {
    _movieListState!.setSelectedMovieId(movieId);
  }
}
