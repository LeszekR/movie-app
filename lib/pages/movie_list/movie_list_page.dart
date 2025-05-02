import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_content.dart';
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
  MovieListController? controller;

  @override
  void initState() {
    super.initState;
    // TODO - DI
    controller = MovieListController(widget.apiService);
  }

  @override
  Widget build(BuildContext context) => Consumer<MovieListContent>(builder: (context, movieListProvider, child) {
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
        separatorBuilder: (context, index) => Container(
          height: 1.0,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) => MovieCard(
          id: movies[index].id,
          title: movies[index].title,
          rating: '${(movies[index].voteAverage * 10).toInt()}%',
          onTap: _onMovieTap,
        ),
        itemCount: movies.length,
      );

  void _onSearchBoxSubmitted(String? query) async {
    if (query == null) return;
    var fetchedMovieList = await controller!.fetchMovieList(query);
    if (fetchedMovieList == null) return;
    if (!mounted) return;
    var movieListContent = context.read<MovieListContent>();
    controller!.updateMovieList(movieListContent, fetchedMovieList);
  }

  void _onOpenMovieDetailsTap() async {
    if (controller!.movieId == null) return;
    var fetchedMovie = await controller!.fetchMovie(controller!.movieId!);
    if (fetchedMovie == null) return;
    if (!mounted) return;
    controller!.openMovieDetails(context, fetchedMovie, controller!.movieId!);
  }

  void _onMovieTap(int id) {
    setState(() {
      controller!.movieId = id;
    });
  }
}
