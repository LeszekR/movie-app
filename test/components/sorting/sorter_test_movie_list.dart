part of 'sorter_test.dart';


String _movieListString(List<TMovie> movieList) {
  return movieList.map((tMovie) => tMovie.toString()).toList().toString();
}

class TMovie extends Movie {
  const TMovie({required super.title, required super.voteAverage, required super.budget}) : super(id: 0, revenue: 0);

  @override
  Map<String, Comparable<dynamic>> getSortableFieldsMap() {
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

List<TMovie> makeBlocTestMovieList() => [
  const TMovie(title: 'aa', voteAverage: 1, budget: 1),
  const TMovie(title: 'aa', voteAverage: 5, budget: 0),
  const TMovie(title: 'ab', voteAverage: 7, budget: 4),
  const TMovie(title: 'ba', voteAverage: 5, budget: 5),
  const TMovie(title: 'bb', voteAverage: 1, budget: 5),
  const TMovie(title: 'bb', voteAverage: 5, budget: 2),
];
