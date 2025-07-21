import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/components/search_box.dart';
import 'package:flutter_demo/fca/domain/usecases/get_movie_details_usecase.dart';
import 'package:flutter_demo/fca/domain/usecases/get_searched_movies_usecase.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_view_state_data.dart';
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
    getit.registerLazySingleton<MoviesRepository>(() => MockDataMoviesRepository());

    getit.registerLazySingleton(() => GetMovieDetailsUseCase(getit<MoviesRepository>()));
    getit.registerLazySingleton(() => GetSearchedMoviesUseCase());
    getit.registerLazySingleton(() => MovieListPresenter());

    getit.registerLazySingleton(() => MovieListState());
    getit.registerLazySingleton(() => MovieListScrollController());
    getit.registerLazySingleton(() => SearchMoviesTextEditingController());
    getit.registerLazySingleton(() => MovieListBloc());
  });

  tearDown(() {
    getit.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when((getit<MoviesRepository>() as MockDataMoviesRepository).getSearchedMovies(any))
        .thenAnswer((_) => Future.value(fetchedMovieList));

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
