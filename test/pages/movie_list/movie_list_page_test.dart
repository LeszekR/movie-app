import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/components/search_box.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import '../../utils/sorting/sorter_test.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([MoviesRepository])
main() {
  var getit = GetIt.instance;

  setUp(() {
    getit.registerLazySingleton<MoviesRepository>(() => MockMoviesRepository());
  });

  tearDown(() {
    getit.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when((getit<MoviesRepository>() as MockMoviesRepository).getSearchedMovies(any))
        .thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester,
        widgetBuilder: () => BlocProvider(
              create: (context) => MovieListBloc(moviesRepository: getit<MoviesRepository>()),
              child: MovieListView(),
            ));

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
