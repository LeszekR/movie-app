import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/domain/entities/movie.dart';
import 'package:flutter_recruitment_task/domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/scroll_controller.dart';
import '../../components/search_box/search_box.dart';
import '../../components/search_box/search_text_controller.dart';
import '../../navigation/go_router_const_strings.dart';
import 'components/movie_card.dart';
import 'controller/movie_list_controller.dart';
import 'controller/state/movie_list_state.dart';

class MovieListPage extends ConsumerStatefulWidget {
  // TODO refactor to flutter_clean_architecture

  const MovieListPage({super.key});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends ConsumerState<MovieListPage> {
  MovieListState? _state;
  MovieListController? _manager;
  ScrollController? _scrollController;
  TextEditingController? _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Txt.setLanguage(context);

    _state = ref.read(movieListStateProvider.notifier);
    _manager = ref.read(movieListControllerProvider);
    _scrollController = ref.read(movieListScrollControllerProvider);
    _searchController = ref.read(searchBoxTextControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _manager!.restoreScroll();
      _manager!.restoreSearchQuery();
    });
  }

  @override
  Widget build(BuildContext context) {
    var movieListData = ref.watch(movieListStateProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.movie_creation_outlined),
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

  void _onSearchBoxSubmitted(String query) async {
    if (query.isEmpty) return;

    var fetchedMovieList = await _manager!.fetchMovieList(query);
    if (fetchedMovieList == null) return;
    if (fetchedMovieList.isEmpty) return;

    if (!mounted) return;
    _manager!.updateMovieList(fetchedMovieList);
  }

  void _onOpenMovieDetailsTap() async {
    var selectedMovieId = _state!.getSelectedMovieId();
    if (selectedMovieId == null) return;

    var fetchedMovie = await _manager!.fetchMovie(selectedMovieId);
    if (fetchedMovie == null) return;

    if (!mounted) return;

    _saveViewParams();

    context.goNamed(
      routeMovieDetails,
      pathParameters: {
        paramMovieTitle: fetchedMovie.title.toString(),
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
