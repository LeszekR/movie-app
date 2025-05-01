import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';

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
  Future<List<Movie>> _movieList = Future.value([]);
  int? _selectedMovieId;

  @override
  void initState() {
    super.initState;
    // TODO - DI
    controller = MovieListController(widget.apiService);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.movie_creation_outlined),
              onPressed: controller!.openMovieDetails(context),
            ),
          ],
          title: Text('Movie Browser'),
        ),
        body: Column(
          children: <Widget>[
            SearchBox(onSubmitted: _onSearchBoxSubmitted),
            Expanded(child: _buildContent()),
          ],
        ),
      );

  Widget _buildContent() => FutureBuilder<List<Movie>>(
      future: _movieList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(snapshot.error.toString()),
          );
        } else {
          return _buildMoviesList(snapshot.data ?? []);
        }
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

  void _onSearchBoxSubmitted(String query) {
    setState(() {
      _movieList = controller!.onSearchBoxSubmitted(query);
    });
  }

  void _onMovieTap(int id) {
    setState(() {
      _selectedMovieId = id;
    });
    print('Selected Movie ID: $_selectedMovieId');
  }
}
