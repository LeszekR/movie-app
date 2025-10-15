import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/components/search_box.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools/controller_test/utils.dart';
import '../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../test_tools/test_utils.dart';
import '../../components/sorting/sorter_test.dart';

void main() {
  final MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();

  setUp(() async {
    await loadConfigFile();
    getIt.registerLazySingleton(MovieListState.new);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('fetched movies are sorted', (WidgetTester tester) async {
    final fetchedMovieList = makeTestMovieList();
    final fetchedFirstTitle = fetchedMovieList[0].title;

    when(mockDataMovieRepository.getSearchedMovies(any)).thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester, language: 'pl', widgetBuilder: () => makeMovieListView(mockDataMovieRepository));

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
