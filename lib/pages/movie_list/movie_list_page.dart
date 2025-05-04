import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/pages/movie_list/state/movie_list_state.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/go_router_const_strings.dart';
import 'controllers/movie_list_manager.dart';
import 'controllers/search_text_controller.dart';

class MovieListPage extends ConsumerStatefulWidget {
  const MovieListPage({super.key});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends ConsumerState<MovieListPage> {
  MovieListState? _state;
  MovieListManager? _manager;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _state = ref.watch(movieListStateProvider.notifier);
    _manager = ref.read(movieListManagerProvider);

    ScrollController scrollController = ref.read(movieListScrollControllerProvider);
    scrollController.addListener(() {
      _state!.setScrollOffset(scrollController.offset);
    });

    TextEditingController searchController = ref.read(searchBoxTextControllerProvider);
    searchController.addListener(() {
      _state!.setSearchQuery(searchController.text);
    });

    _manager!.restoreScroll();
    _manager!.restoreSearchQuery();
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
            Expanded(child: _buildMoviesList(_state!.getMovieList().results)),
          ],
        ),
      );

  Widget _buildMoviesList(List<Movie> movies) => ListView.separated(
        controller: ref.read(movieListScrollControllerProvider),
        separatorBuilder: (context, index) => Container(
          height: 1.0,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) => MovieCard(
          id: movies[index].id,
          title: movies[index].title,
          rating: '${(movies[index].voteAverage * 10).toInt()}%',
          onTap: _onMovieTap,
          isSelected: movies[index].id == _state!.getSelectedMovieId(),
        ),
        itemCount: movies.length,
      );

  void _onSearchBoxSubmitted(String? query) async {
    if (query == null) return;

    var fetchedMovieList = await _manager!.fetchMovieList(query);
    if (fetchedMovieList == null) return;

    if (!mounted) return;
    _manager!.updateMovieList(fetchedMovieList);
  }

  void _onOpenMovieDetailsTap() async {
    if (_state!.getSelectedMovieId() == null) return;

    var fetchedMovie = await _manager!.fetchMovie(_state!.getSelectedMovieId()!);
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
    _state!.setSelectedMovieId(movieId);
  }
}
