import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/movie_list_manager.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/scroll_controller.dart';
import 'package:flutter_recruitment_task/pages/movie_list/controllers/search_text_controller.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/pages/movie_list/state/movie_list_state.dart';
import 'package:flutter_recruitment_task/routing/go_router_const_strings.dart';
import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieListPage extends ConsumerStatefulWidget {
  const MovieListPage({super.key});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends ConsumerState<MovieListPage> {
  MovieListState? _state;
  MovieListManager? _manager;
  ScrollController? _scrollController;
  TextEditingController? _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Txt.setLanguage(context);

    _state = ref.read(movieListStateProvider.notifier);
    _manager = ref.read(movieListManagerProvider);
    _scrollController = ref.read(movieListScrollControllerProvider);
    _searchController = ref.read(searchBoxTextControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _manager!.restoreScroll();
      _manager!.restoreSearchQuery();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieListData = ref.watch(movieListStateProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.movie_creation_outlined),
            onPressed: _onOpenMovieDetailsTap,
          ),
        ],
        title: Text(Txt.get.movie_list_title),
      ),
      body: Column(
        children: <Widget>[
          SearchBox(onSubmitted: _onSearchBoxSubmitted),
          Expanded(child: _buildMoviesList(movieListData.movieList.results)),
        ],
      ),
    );
  }

  Widget _buildMoviesList(List<Movie> movies) => ListView.separated(
        controller: _scrollController,
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

  Future<void> _onSearchBoxSubmitted(String query) async {
    if (query.isEmpty) return;

    final fetchedMovieList = await _manager!.fetchMovieList(query);
    if (fetchedMovieList == null) return;
    if (fetchedMovieList.isEmpty) return;

    if (!mounted) return;
    _manager!.updateMovieList(fetchedMovieList);
  }

  Future<void> _onOpenMovieDetailsTap() async {
    final selectedMovieId = _state!.getSelectedMovieId();
    if (selectedMovieId == null) return;

    final fetchedMovie = await _manager!.fetchMovie(selectedMovieId);
    if (fetchedMovie == null) return;

    if (!mounted) return;

    _saveViewParams();

    context.goNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: fetchedMovie.title,
        paramMovieBudget: fetchedMovie.budget.toString(),
        paramMovieRevenue: fetchedMovie.revenue.toString(),
      },
    );
  }

  void _saveViewParams() {
    _state!.setSearchQuery(_searchController!.text);
    _state!.setScrollOffset(_scrollController!.offset);
  }

  void _onMovieTap(int movieId) {
    _state!.setSelectedMovieId(movieId);
  }
}
