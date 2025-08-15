import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_colors.dart';
import 'package:flutter_demo/common/config/app_config.dart';
import 'package:flutter_demo/components/search_box.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_details/view/movie_details_view.dart';
import 'package:flutter_demo/features/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/features/two_buttons/components/button_two_states.dart';
import 'package:flutter_demo/features/two_buttons/view/two_buttons_view.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/features/movie_app.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/common_mocks.mocks.dart';
import 'navigation_test_data.dart';

void main() {
  var mockMoviesRepository = MockMoviesRepository();
  int selectedIndex = (nMovies * .8).toInt();
  var selectedTitle = makeMovieTitle(selectedIndex);
  var movieList = makeNavTestMovieList();
  var searchQuery = 'Drama';

  // must be either late or in further code complete not with just movie but Future.value(movie)
  // late Completer<Movie> movieCompleter = Completer(); // version shorter but less explicit than completer.complete(Future.value(...))
  Completer<Movie> movieCompleter = Completer(); // verbose version requiring completer.complete(Future.value(...))

  setUpAll(() {
    initGetIt();
    getit.unregister<MoviesRepository>();
    getit.registerLazySingleton<MoviesRepository>(() {
      return mockMoviesRepository;
    });

    dotenv.testLoad(fileInput: File(AppConfig.configFilePath).readAsStringSync());

    when(mockMoviesRepository.getSearchedMovies(any)).thenAnswer((_) => Future.value(movieList));
    when(mockMoviesRepository.getMovie(selectedIndex)).thenAnswer((_) => movieCompleter.future);
  });

  testWidgets('all navigation transitions without errors', (final tester) async {
    await tester.pumpWidget(const MovieApp());

    // filling the search box
    var searchBox = find.byKey(SearchBox.keySearchBox);
    await tester.tap(searchBox);
    await tester.enterText(searchBox, searchQuery);

    // pulling movies from the service
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text(searchQuery), findsOneWidget);
    expect(find.text(makeMovieTitle(1)), findsOneWidget);

    // scrolling down
    var movieListFinder = find.byKey(MovieListView.listViewKey);
    final listFinder = find.descendant(of: movieListFinder, matching: find.byType(Scrollable));
    final movieFinder = find.text(makeMovieTitle(selectedIndex));
    expect(movieFinder, findsNothing);
    await tester.scrollUntilVisible(movieFinder, 700, scrollable: listFinder);
    expect(find.text(selectedTitle), findsOneWidget);

    // selecting one movie from the list
    await tester.tap(movieFinder);
    await tester.pump();
    expect(selectedMovieColor(tester, movieFinder), AppColors.selectedTableRowBackground);

    // showing progress bar
    await tester.tap(find.byKey(MovieListView.movieDetailsButtonKey));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // showing selected movie details in MovieDetailsView
    // movieCompleter.complete(movieList[selectedIndex]);    // version with late Completer
    movieCompleter.complete(Future.value(movieList[selectedIndex])); // version with explicit Future returned
    await pumpUntilFound(tester, find.byType(MovieDetailsView));

    // coming back to MovieListView
    await tester.tap(find.byType(BackButton));
    await tester.pump();

    // checking whether MovieListView maintained its selection, scroll and search box query (its state)
    expect(find.byType(SearchBox), findsOneWidget);
    expect(find.text(makeMovieTitle(1)), findsNothing);
    expect(find.text(selectedTitle), findsOneWidget);

    // navigating to TwoButtonsView
    await tester.tap(find.byKey(MovieListView.twoButButtonKey));
    await pumpUntilFound(tester, find.byType(TwoButtonsView));

    // clicking a button what changes its color
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOff);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOff);

    await tester.tap(findTwoStateButton(TwoButtonsView.button1Key));
    await tester.pump();

    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOn);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOff);

    // navigating back to MovieListView
    await tester.tap(find.byKey(TwoButtonsView.movieListButtonKey));
    await pumpUntilFound(tester, find.byType(MovieListView));

    // checking its state again
    expect(find.text(searchQuery), findsOneWidget);
    expect(find.text(makeMovieTitle(1)), findsNothing);
    expect(find.text(selectedTitle), findsOneWidget);

    // navigating to TwoButtonsView
    expect(find.byKey(MovieListView.twoButButtonKey), findsOneWidget);
    await tester.tap(find.byKey(MovieListView.twoButButtonKey));
    await pumpUntilFound(tester, find.byType(TwoButtonsView));

    // checking TwoButtonsView state - the buttons colors
    expect(findTwoStateButton(TwoButtonsView.button1Key), findsOneWidget);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOn);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOff);
  });
}

Container findTwoStateButtonContainer(WidgetTester tester, Key key) {
  var finder = find.descendant(of: findTwoStateButton(key), matching: find.byType(Container));
  return tester.widget<Container>(finder);
}

Finder findTwoStateButton(Key key) => find.byKey(key);

Color? selectedMovieColor(WidgetTester tester, Finder movieFinder) {
  var ancestorContainer = tester.widget(find.ancestor(of: movieFinder, matching: find.byType(Container)));
  return ((ancestorContainer as Container).decoration as BoxDecoration).color;
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 2),
  Duration step = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      // must be pumpAndSettle(), NOT just pump(), since in test Flutter can keep temp copies of widgets in the tree...
      // ... we want to get rid of them...
      // Even after popping a route, widgets from the previous screen might linger for a few frames in the tree
      // — just long enough to confuse find!
      await tester.pumpAndSettle();
      return;
    }
  }
  throw TestFailure('Timeout: widget not found: $finder');
}
