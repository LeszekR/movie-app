part of 'movie_list_bloc_test.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState> implements MovieListBloc {}

class _MovieListBlocTestCase {
  final String title;
  final MovieListEvent event;
  final MovieListState state;
  const _MovieListBlocTestCase(this.title, this.event, this.state);
}

String _searchQuery_A = 'query 1';
String _searchQuery_B = 'query 2';
String _searchQueryNotFound = 'query not found';
String _searchQueryHttpErr = 'query http err';
String _searchQueryOtherErr = 'query other err';

int _movieId_A2 = 2;
int _movieId_B6 = 6;
int _movieIdErrHttp = 11;
int _movieIdErrOther = 12;

MovieList _testMovieList_A() => MovieList(totalResults: 3, results: [
      Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
      Movie(id: 1, budget: 111, revenue: 811, voteAverage: 1.2, title: 'TestMovie 1'),
      Movie(id: 2, budget: 122, revenue: 822, voteAverage: 2.2, title: 'TestMovie 2'),
      Movie(id: 3, budget: 133, revenue: 833, voteAverage: 3.2, title: 'TestMovie 3'),
    ]);

MovieList _testMovieList_B() => MovieList(totalResults: 3, results: [
      Movie(id: 0, budget: 100, revenue: 800, voteAverage: 0.2, title: 'TestMovie 0'),
      Movie(id: 4, budget: 144, revenue: 844, voteAverage: 4.2, title: 'TestMovie 4'),
      Movie(id: 5, budget: 155, revenue: 855, voteAverage: 5.2, title: 'TestMovie 5'),
      Movie(id: 6, budget: 166, revenue: 866, voteAverage: 6.2, title: 'TestMovie 6'),
    ]);

MovieList _movieListEmpty() => MovieList(totalResults: 0, results: []);

int _selectedId_1 = 3;
int _selectedId_2 = 150;
int _selectedId_3 = 18;
int _selectedId_4 = 15685;
int _selectedId_5 = 85248;

double _scrollOffset_1 = 8;
double _scrollOffset_2 = 230;
double _scrollOffset_3 = 15;
double _scrollOffset_4 = 1;
double _scrollOffset_5 = 85;
