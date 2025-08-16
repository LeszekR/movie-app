import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void stateComparator<C, T>(C controller, T expected) {
  if (controller is MovieListController && expected is MovieListState) {
    var actualState = (controller as MovieListController).state;
    var expectedState = expected as MovieListState;

    expect(actualState.selectedMovieId.value, expectedState.selectedMovieId.value);
    expect(actualState.scrollOffset, expectedState.scrollOffset);
    expect(actualState.searchQuery, expectedState.searchQuery);
    expect(listEquals(actualState.sortCriteriaList, expectedState.sortCriteriaList), true);
    expect(actualState.navCommand, expectedState.navCommand);
    expect(actualState.restoreView, expectedState.restoreView);
  } else {
    throw UnimplementedError('stateComparator has no case for ${T.runtimeType}');
  }
}
