import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common/config/app_config.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/search_box.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/movie_list/view/components/movie_card.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/features/two_buttons/two_button_navigation/two_button_navigator.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../components/sorting/sorter_test.dart';
import '../../test_utils.dart';
import 'movie_list_view_test.mocks.dart';

@GenerateMocks([MoviesRepository])
main() {
  var getit = GetIt.instance;

  setUp(() {
    getit.registerSingleton(Txt());
    getit.registerLazySingleton(() => Sorter<Movie>());
    getit.registerLazySingleton(() => AppConfig());
    getit.registerSingleton(DateTimeReader());
    getit.registerLazySingleton(() => DialogFactory(getit<Txt>()));
    getit.registerLazySingleton(() => AppNavigator(
          getit<Txt>(),
          getit<DialogFactory>(),
          getit<MovieListNavigator>(),
          getit<TwoButtonNavigator>(),
        ));
    getit.registerLazySingleton(() => MovieListNavigator(getit<Txt>(), getit<MovieDetailsController>()));
    getit.registerLazySingleton<MoviesRepository>(() => MockMoviesRepository());
    getit.registerLazySingleton(() => TwoButtonNavigator());
    getit.registerFactory(() => MovieDetailsController(getit<DateTimeReader>(), getit<AppConfig>()));
    getit.registerFactory(() => MovieListScrollController());
  });

  tearDown(() {
    getit.reset();
  });

  testWidgets('fetched movies are sorted', (final WidgetTester tester) async {
    var fetchedMovieList = makeTestMovieList();
    var fetchedFirstTitle = fetchedMovieList[0].title;

    when((getit<MoviesRepository>() as MockMoviesRepository).getSearchedMovies(any))
        .thenAnswer((_) => Future.value(fetchedMovieList));

    await prepareWidget(tester, getit,
        widgetBuilder: () => BlocProvider(
              create: (context) => MovieListBloc(getit<MoviesRepository>(), getit<Sorter<Movie>>()),
              child: MovieListView(
                txt: getit<Txt>(),
                appNavigator: getit<AppNavigator>(),
                moviesNavigator: getit<MovieListNavigator>(),
                scrollController: getit<MovieListScrollController>(),
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
