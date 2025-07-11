import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/app/components/search_box/search_box.dart';
import 'package:flutter_recruitment_task/app/pages/movie_list/components/movie_card.dart';
import 'package:flutter_recruitment_task/app/pages/movie_list/movie_list_view.dart';
import 'package:flutter_recruitment_task/data/repositories/data_movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import '../../utils/sorting/sorter_test.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([DataMoviesRepository])
void main() {
  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    var mockDataMoviesRepository = MockDataMoviesRepository();
    when(mockDataMoviesRepository.getSearchedMovies(any)).thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester,
        widgetBuilder: () => MovieListPage(), overrides: [dataMoviesRepositoryProvider.overrideWith((ref) => mockDataMoviesRepository)]);

    var searchBox = find.byKey(SearchBox.keySearchBox);
    await tester.tap(searchBox);
    await tester.enterText(searchBox, 'avatar');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    var movieCardTitleFinder = find.descendant(
      of: find.byType(MovieCard).first,
      matching: find.byType(Text),
    );
    var actualFirstTitle = tester.widget<Text>(movieCardTitleFinder.first).data!;

    // title with highest rateAverage in makeTestMovieList()
    // assumption valid with MovieListPageManager first sortCriteria = SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    var expectedFirstTitle = 'ab';

    expect(fetchedFirstTitle, isNot(equals(actualFirstTitle)));
    expect(expectedFirstTitle, actualFirstTitle);
  });
}
