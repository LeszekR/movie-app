import 'package:flutter_demo/pages/movie_details/model/movie.dart';

var nMovies = 30;

List<Movie> makeNavTestMovieList() {
  List<Movie> movies = [];
  var indexList = List.generate(nMovies, (int i) => i + 1);
  for (var i in indexList) {
    movies.add(Movie(
      id: i,
      title: makeMovieTitle(i),
      budget: makeBudget(i),
      revenue: makeRevenue(i),
      voteAverage: makeVoteAverage(i),
    ));
  }
  return movies;
}

String makeMovieTitle(int i) => 'Drama $i';

double makeVoteAverage(int i) => 50 / (i + 1);  // don't change - Bloc will sort them by voteAverage, we want the first to be first

int makeRevenue(int i) => i * 11111;

int makeBudget(int i) => i * 1000;
