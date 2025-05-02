import 'package:flutter/cupertino.dart';

import '../models/movie_list.dart';

class MovieListStore extends ChangeNotifier {
  MovieList _movieList = MovieList(totalResults: 0, results: []);
  final TextEditingController _searchBoxTextController = TextEditingController();
  double lastScrollOffset = 0;
  int? selectedMovieId;

  MovieList get movieList => _movieList;

  TextEditingController get searchBoxTextController => _searchBoxTextController;

  void updateMovieList(MovieList movieList) {
    _movieList = movieList;
    notifyListeners();
  }
}
