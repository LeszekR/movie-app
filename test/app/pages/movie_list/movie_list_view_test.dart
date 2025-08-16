import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/components/search_box.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/app/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../test_tools/test_utils.dart';
import '../../components/sorting/sorter_test.dart';


main() {
  MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();

  setUp(() async {
    initGetIt();
    getIt.unregister<DataMovieRepository>();
    getIt.registerLazySingleton<DataMovieRepository>(() => mockDataMovieRepository);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when(mockDataMovieRepository.getSearchedMovies(any)).thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester, widgetBuilder: () => MovieListView());

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
