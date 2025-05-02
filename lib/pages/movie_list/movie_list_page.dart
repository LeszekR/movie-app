import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_store.dart';
import 'package:provider/provider.dart';

import 'movie_list_controller.dart';

class MovieListPage extends StatefulWidget {
  final ApiService apiService;

  // TODO - DI
  const MovieListPage({super.key, required this.apiService});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends State<MovieListPage> {
  MovieListController? _controller;
  ScrollController? _scrollController;
  MovieListStore? _movieListStore;

  @override
  void initState() {
    super.initState;
    // TODO - DI
    _controller = MovieListController(widget.apiService);
    _scrollController = ScrollController();
    _movieListStore = context.read<MovieListStore>();

    _scrollController?.addListener(() {
      _movieListStore!.lastScrollOffset = _scrollController!.offset;
    });
    _controller!.restoreScroll(_movieListStore!, _scrollController!);
  }

  @override
  Widget build(BuildContext context) => Consumer<MovieListStore>(builder: (context, movieListProvider, child) {
        return Scaffold(
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
              Expanded(child: _buildMoviesList(movieListProvider.movieList.results)),
            ],
          ),
        );
      });

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
          isSelected: movies[index].id == _movieListStore!.selectedMovieId,
        ),
        itemCount: movies.length,
      );

  void _onSearchBoxSubmitted(String? query) async {
    if (query == null) return;
    var fetchedMovieList = await _controller!.fetchMovieList(query);
    if (fetchedMovieList == null) return;
    if (!mounted) return;
    var movieListContent = context.read<MovieListStore>();
    _controller!.updateMovieList(movieListContent, fetchedMovieList);
  }

  void _onOpenMovieDetailsTap() async {
    if (_movieListStore!.selectedMovieId == null) return;
    var fetchedMovie = await _controller!.fetchMovie(_movieListStore!.selectedMovieId!);
    if (fetchedMovie == null) return;
    _movieListStore!.lastScrollOffset = _scrollController!.offset;
    _movieListStore!.selectedMovieId = _movieListStore!.selectedMovieId;
    if (!mounted) return;
    _controller!.openMovieDetails(context, fetchedMovie, _movieListStore!.selectedMovieId!);
  }

  void _onMovieTap(int id) {
    setState(() {
      _movieListStore!.selectedMovieId = id;
    });
  }
}
