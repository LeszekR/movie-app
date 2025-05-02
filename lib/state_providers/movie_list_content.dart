import 'package:flutter/cupertino.dart';

import '../models/movie_list.dart';

class MovieListContent extends ChangeNotifier {
  MovieList _movieList = MovieList(totalResults: 0, results: []);
  TextEditingController _searchBoxTextController = TextEditingController();

  MovieList get movieList => _movieList;

  TextEditingController get searchBoxTextController => _searchBoxTextController;

  void updateMovieList(MovieList movieList) {
    _movieList = movieList;
    notifyListeners();
  }
}
