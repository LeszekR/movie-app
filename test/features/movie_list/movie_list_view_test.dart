import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/components/search_box.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../components/sorting/sorter_test.dart';
import '../../mocks/common_mocks.mocks.dart';
import '../../test_utils.dart';

@GenerateMocks([MoviesRepository])
main() {

  setUp(() {
    initGetIt();
    getIt.unregister<MoviesRepository>();
    getIt.registerLazySingleton<MoviesRepository>(() => MockMoviesRepository());
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeBlocTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when((getIt<MoviesRepository>() as MockMoviesRepository).getSearchedMovies(any))
        .thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester, getIt,
        widgetBuilder: () => BlocProvider(
              create: (context) => MovieListBloc(getIt<MoviesRepository>(), getIt<Sorter<Movie>>()),
              child: MovieListView(
                txt: getIt<Txt>(),
                appNavigator: getIt<AppNavigator>(),
                moviesNavigator: getIt<MovieListNavigator>(),
              ),
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
