import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/app/components/search_box.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/pages/movie_app/view/movie_app.dart';
import 'package:flutter_demo/app/pages/movie_details/view/movie_details_view.dart';
import 'package:flutter_demo/app/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/app/pages/two_buttons/view/components/button_two_states.dart';
import 'package:flutter_demo/app/pages/two_buttons/view/two_buttons_view.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_tools/mocks/common_mocks.mocks.dart';
import '../../test_tools/test_utils.dart';
import 'navigation_test_data.dart';

void main() {
  var mockDataMovieRepository = MockDataMovieRepository();
  int selectedIndex = (nMovies * .8).toInt();
  var selectedTitle = makeMovieTitle(selectedIndex);
  var movieList = makeNavTestMovieList();
  var searchQuery = 'Drama';

  // must  either a) be late or b) finally complete not with just movie but Future.value(movie)
  // decided on b) explicit return of a Future - for code readability
  // late Completer<Movie> movieCompleter = Completer(); // version shorter but less explicit than completer.complete(Future.value(...))
  Completer<Movie> movieCompleter = Completer(); // verbose version requiring completer.complete(Future.value(...))

  setUpAll(() async {
    await loadConfigFile();
    initGetIt();
    getIt.unregister<DataMovieRepository>();
    getIt.registerLazySingleton<DataMovieRepository>(() => mockDataMovieRepository);

    dotenv.testLoad(fileInput: File(AppParams.configFilePath).readAsStringSync());

    when(mockDataMovieRepository.getSearchedMovies(any)).thenAnswer((_) => Future.value(movieList));
    when(mockDataMovieRepository.getMovie(selectedIndex)).thenAnswer((_) => movieCompleter.future);
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
    expect(listFinder, findsOneWidget);
    final movieFinder = find.text(selectedTitle);
    expect(movieFinder, findsNothing);
    await tester.scrollUntilVisible(movieFinder, 900, scrollable: listFinder);
    expect(movieFinder, findsOneWidget);

    // selecting one movie from the list
    await tester.tap(movieFinder);
    await tester.pump();
    // await tester.scrollUntilVisible(movieFinder, 900, scrollable: listFinder);  // KEEP THIS LINE HERE! Flutter test tap can scroll the widget out!
    expect(movieFinder, findsOneWidget);
    expect(selectedMovieColor(tester, movieFinder), AppColors.selectedTableRowBackground);

    // showing progress bar
    await tester.tap(find.byKey(MovieListView.movieDetailsButtonKey));
    await tester.pump();
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
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOn);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOn);

    await tester.tap(findTwoStateButton(TwoButtonsView.button1Key));
    await tester.pump();

    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOff);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOn);

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
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button1Key).color, ButtonTwoStates.colorOff);
    expect(findTwoStateButtonContainer(tester, TwoButtonsView.button2Key).color, ButtonTwoStates.colorOn);
  });
}

Finder findTwoStateButton(Key key) {
  return find.byKey(key);
}

Container findTwoStateButtonContainer(WidgetTester tester, Key key) {
  var finder = find.descendant(of: findTwoStateButton(key), matching: find.byType(Container));
  return tester.widget<Container>(finder);
}

Color? selectedMovieColor(WidgetTester tester, Finder movieFinder) {
  expect(movieFinder, findsOneWidget);
  final ancestor = find.ancestor(of: movieFinder, matching: find.byType(ColoredBox));
  expect(ancestor, findsOneWidget);
  final coloredBox = tester.widget<ColoredBox>(ancestor);
  return coloredBox.color;
}
