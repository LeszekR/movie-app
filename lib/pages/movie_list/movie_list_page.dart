import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/sorting/column_sort_criteria.dart';
import 'package:flutter_recruitment_task/utils/sorting/e_sort_direction.dart';
import 'package:flutter_recruitment_task/utils/sorting/sortable_sorter.dart';
import 'package:go_router/go_router.dart';

import '../../utils/routing/go_router_const_strings.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  MovieListPageState createState() => MovieListPageState();
}

class MovieListPageState extends State<MovieListPage> {
  final apiService = ApiService();

  Future<List<Movie>> _movieList = Future.value([]);

  final SortableSorter<Movie> _movieSorter = SortableSorter();
  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    SortCriteria(Movie.keyTitle, ESortDirection.asc),
  ];

  var selectedMovieBudget_DUMMY = '5000000';
  var selectedMovieRevenue_DUMMY = '8000000';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.movie_creation_outlined),
              // onPressed: () {
              //   //TODO implement navigation
              // },
              onPressed: _openMovieDetails(context),
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
          title: movies[index].title,
          rating: '${(movies[index].voteAverage * 10).toInt()}%',
        ),
        itemCount: movies.length,
      );

  void _onSearchBoxSubmitted(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _movieList = apiService.searchMovies(query).then((movies) {
          _movieSorter.sortColumns(movies, sortCriteriaList: _sortCriteriaList);
          return Future.value(movies);
        });
      } else {
        _movieList = Future.value([]);
      }
    });
  }

  GestureTapCallback? _openMovieDetails(BuildContext context) {
    return () {
      context.goNamed(
        routeMovieDetails,
        pathParameters: {paramMovieBudget: selectedMovieBudget_DUMMY, paramMovieRevenue: selectedMovieRevenue_DUMMY},
      );
    };
  }
}
