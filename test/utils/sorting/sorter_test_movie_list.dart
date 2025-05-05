part of 'sorter_test.dart';


String _movieListString(List<_TMovie> movieList) {
  return movieList.map((tMovie) => tMovie.toString()).toList().toString();
}

class _TMovie extends Movie {
  _TMovie({required super.title, required super.voteAverage, required super.budget}) : super(id: 0, revenue: 0);

  @override
  Map<String, dynamic> getSortableFieldsMap() {
    return {Movie.keyTitle: title, Movie.keyVoteAverage: voteAverage, Movie.keyBudget: budget};
  }

  @override
  String toString() => '$title,${voteAverage.toInt()},$budget';
}

class _SorterTestCase {
  final String title;
  final List<SortCriteria> sortCriteriaList;
  final List<String> expectedList;

  const _SorterTestCase(this.title, this.sortCriteriaList, this.expectedList);
}

List<_TMovie> _makeTestMovieList() => [
  _TMovie(title: "aa", voteAverage: 1, budget: 1),
  _TMovie(title: "aa", voteAverage: 5, budget: 0),
  _TMovie(title: "ab", voteAverage: 7, budget: 4),
  _TMovie(title: "ba", voteAverage: 5, budget: 5),
  _TMovie(title: "bb", voteAverage: 1, budget: 5),
  _TMovie(title: "bb", voteAverage: 5, budget: 2),
];
