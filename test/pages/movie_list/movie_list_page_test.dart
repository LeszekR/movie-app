import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import '../../utils/sorting/sorter_test.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  testWidgets('fetched movies are sorted', (WidgetTester tester) async {
    final fetchedMovieList = makeTestMovieList();
    final fetchedFirstTitle = fetchedMovieList[0].title;

    final mockApiService = MockApiService();
    when(mockApiService.searchMovies(any)).thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(
      tester,
      widgetBuilder: MovieListPage.new,
      overrides: [apiServiceProvider.overrideWith((ref) => mockApiService)],
    );

    final searchBox = find.byKey(SearchBox.keySearchBox);
    await tester.tap(searchBox);
    await tester.enterText(searchBox, 'avatar');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    final movieCardTitleFinder = find.descendant(
      of: find.byType(MovieCard).first,
      matching: find.byType(Text),
    );
    final actualFirstTitle = tester.widget<Text>(movieCardTitleFinder.first).data!;

    // title with highest rateAverage in makeTestMovieList()
    // assumption valid with MovieListPageManager first sortCriteria = SortCriteria(Movie.keyVoteAverage, ESortDirection.desc),
    const expectedFirstTitle = 'ab';

    expect(fetchedFirstTitle, isNot(equals(actualFirstTitle)));
    expect(expectedFirstTitle, actualFirstTitle);
  });
}
