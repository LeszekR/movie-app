part of 'movie_list_bloc_test.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _MovieListBlocTestCase {
  final String title;
  final MovieListEvent event;
  final List<MovieListState> states;
  final int skip;
  final void Function()? verify;

  // final VerificationResult Function<T>(T matchingInvocations)? verify;
  // final dynamic Function(MovieListBloc bloc)? verify;
  const _MovieListBlocTestCase({
    required this.title,
    required this.event,
    required this.states,
    this.skip = 0,
    this.verify,
  });
}

String _searchQuery_A = 'QUERY_A';
String _searchQuery_B = 'QUERY_B';
String _searchQueryNotFound = 'QUERY_NOT_FOUND';
String _searchQueryHttpErr = 'QUERY_HTTP_ERR';
String _searchQueryOtherErr = 'QUERY_OTHER_ERR';

int _movieId_A2 = 2;
int _movieId_B6 = 6;
int _movieIdErrHttp = 11;
int _movieIdErrOther = 12;


MovieList _testMovieList_A() => MovieList(
    totalResults: 4,
    results: Sorter<Movie>().sortColumns([
      Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
      Movie(id: 1, budget: 111, revenue: 811, voteAverage: 1.2, title: 'TestMovie 1'),
      Movie(id: 2, budget: 122, revenue: 822, voteAverage: 2.2, title: 'TestMovie 2'),
      Movie(id: 3, budget: 133, revenue: 833, voteAverage: 3.2, title: 'TestMovie 3'),
    ],
    MovieListState.defaultSortCriteriaList)!);

MovieList _testMovieList_B() => MovieList(
    totalResults: 4,
    results: Sorter<Movie>().sortColumns([
      Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
      Movie(id: 4, budget: 144, revenue: 844, voteAverage: 4.2, title: 'TestMovie 4'),
      Movie(id: 5, budget: 155, revenue: 855, voteAverage: 5.2, title: 'TestMovie 5'),
      Movie(id: 6, budget: 166, revenue: 866, voteAverage: 6.2, title: 'TestMovie 6'),
    ],
    MovieListState.defaultSortCriteriaList)!);

int _selectedId_3 = 3;
int _selectedId_18 = 18;

double _scrollOffset_8 = 8;
double _scrollOffset_230 = 230;
