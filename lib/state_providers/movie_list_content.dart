import 'package:flutter/cupertino.dart';

import '../models/movie_list.dart';

class MovieListContent extends ChangeNotifier {
  MovieList _movieList = MovieList(totalResults: 0, results: []);

  MovieList get movieList => _movieList;

  void updateMovieList(MovieList movieList) {
    _movieList = movieList;
    notifyListeners();
  }
}
