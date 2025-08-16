import 'package:flutter_demo/components/sorting/e_sort_direction.dart';
import 'package:flutter_demo/components/sorting/sort_criteria.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/pages/movie_details/model/movie.dart';
import 'package:flutter_test/flutter_test.dart';

part 'sorter_test_movie_list.dart';

void main() {
  group('sorts hierarchically by multi-column criteria', () {
    Sorter<Movie> sorter = Sorter();
    String expected, actual;
    List<TMovie> movieList;

    List<_SorterTestCase> testCases = [
      _SorterTestCase(
        'voteAverage asc, title desc, budget asc',
        [
          SortCriteria(Movie.keyVoteAverage, ESortDirection.asc),
          SortCriteria(Movie.keyTitle, ESortDirection.desc),
          SortCriteria(Movie.keyBudget, ESortDirection.asc),
        ],
        ['bb,1,5', 'aa,1,1', 'bb,5,2', 'ba,5,5', 'aa,5,0', 'ab,7,4'],
      ),
      _SorterTestCase(
        'budget desc, voteAverage desc, title asc',
        [
          SortCriteria(Movie.keyBudget, ESortDirection.desc),
          SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
          SortCriteria(Movie.keyTitle, ESortDirection.asc),
        ],
        ['ba,5,5', 'bb,1,5', 'ab,7,4', 'bb,5,2', 'aa,1,1', 'aa,5,0'],
      ),
      _SorterTestCase(
        'voteAverage asc, title asc',
        [
          SortCriteria(Movie.keyVoteAverage, ESortDirection.asc),
          SortCriteria(Movie.keyTitle, ESortDirection.asc),
        ],
        ['aa,1,1', 'bb,1,5', 'aa,5,0', 'ba,5,5', 'bb,5,2', 'ab,7,4'],
      ),
    ];

    for (var testCase in testCases) {
      test(testCase.title, () {
        movieList = makeBlocTestMovieList();

        sorter.sortColumns(movieList, testCase.sortCriteriaList);

        expected = testCase.expectedList.toString();
        actual = _movieListString(movieList);

        expect(actual, expected, reason: '====== TEST CASE: ${testCase.title} ======');
      });
    }
  });

  test('throws on criteria field-key absent in sorted type', () {
    Sorter<Movie> sorter = Sorter();
    String badKey1 = 'bad_key_1';
    String badKey2 = 'bad_key_2';
    List<TMovie> movieList = makeBlocTestMovieList();

    List<SortCriteria> sortCriteriaList = [
      SortCriteria(Movie.keyVoteAverage, ESortDirection.asc),
      SortCriteria(badKey1, ESortDirection.desc),
      SortCriteria(badKey2, ESortDirection.desc),
    ];

    expect(
        () => sorter.sortColumns(movieList, sortCriteriaList),
        throwsA(isA<AssertionError>().having(
          (e) => e.message,
          'message',
          sorter.makeErrMsgForeignKeys(movieList[0], '$badKey1,$badKey2'),
        )));
  });

  test('throws on criteria-list longer than class-sortable-fields number', () {
    Sorter<Movie> sorter = Sorter();
    List<TMovie> movieList = makeBlocTestMovieList();

    List<SortCriteria> sortCriteriaList = [
      SortCriteria(Movie.keyVoteAverage, ESortDirection.asc),
      SortCriteria(Movie.keyTitle, ESortDirection.desc),
      SortCriteria(Movie.keyBudget, ESortDirection.asc),
      SortCriteria(Movie.keyTitle, ESortDirection.asc),
    ];

    expect(() => sorter.sortColumns(movieList, sortCriteriaList), throwsAssertionError);
    expect(
        () => sorter.sortColumns(movieList, sortCriteriaList),
        throwsA(isA<AssertionError>().having(
          (e) => e.message,
          'message',
          sorter.makeErrMsgTooManyCriteria(movieList[0], 3, 4),
        )));
  });

  test('accepts empty and null list-to-sort', () {
    Sorter<Movie> sorter = Sorter();

    List<SortCriteria> sortCriteriaList = [
      SortCriteria(Movie.keyVoteAverage, ESortDirection.asc),
      SortCriteria(Movie.keyTitle, ESortDirection.desc),
      SortCriteria(Movie.keyBudget, ESortDirection.asc),
    ];

    // list to sort is empty
    sorter.sortColumns([], sortCriteriaList);

    // list to sort is null
    sorter.sortColumns(null, sortCriteriaList);
  });

  test('accepts empty and null sort-criteria list', () {
    Sorter<Movie> sorter = Sorter();
    List<TMovie> movieList = makeBlocTestMovieList();

    // list to sort is empty
    sorter.sortColumns(movieList, []);

    // list to sort is null
    sorter.sortColumns(movieList, null);
  });
}
