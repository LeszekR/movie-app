import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/app/components/search_box.dart';
import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_demo/app/pages/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/app/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/presenter/movie_list_presenter.dart';
import 'package:flutter_demo/app/pages/two_buttons/two_buttons_navigation/two_buttons_navigator.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';
import 'package:flutter_demo/domain/usecases/movie_details/get_movie_details_usecase.dart';
import 'package:flutter_demo/domain/usecases/movie_list/get_searched_movies_usecase.dart';
import 'package:flutter_demo/domain/utils/logging/logging_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import '../../utils/sorting/sorter_test.dart';
import 'movie_list_page_test.mocks.dart';

@GenerateMocks([DataMovieRepository])
main() {
  var getit = GetIt.instance;

  setUp(() {
    getit.registerSingleton(Txt());
    getit.registerSingleton(AppConfig());
    getit.registerSingleton(LoggingActions());
    getit.registerLazySingleton(() => DialogFactory());
    getit.registerLazySingleton(() => MovieListNavigator());
    getit.registerLazySingleton(() => TwoButtonsNavigator());
    getit.registerSingleton(AppNavigator());

    getit.registerLazySingleton(() => MovieListState());
    getit.registerLazySingleton<DataMovieRepository>(() => MockDataMoviesRepository());
    getit.registerLazySingleton(() => GetMovieDetailsUseCase(getit<DataMovieRepository>()));
    getit.registerLazySingleton(() => GetSearchedMoviesUseCase());
    getit.registerLazySingleton(() => MovieListController());
    getit.registerLazySingleton(() => MovieListPresenter());
  });

  tearDown(() {
    getit.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when((getit<DataMovieRepository>() as MockDataMoviesRepository).getSearchedMovies(any))
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
