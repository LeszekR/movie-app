import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/model/movie_list.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_demo/repositories/movies_repository_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

part 'movie_list_bloc_test_data.dart';
part 'movie_list_bloc_test_cases.dart';

var errSearchHttp = MovieListHttpException(404);
var errMovieHttp = MovieDetailsHttpException(404);
var errRepoOther = Exception('other exception');
MockMoviesRepository mockMoviesRepository = MockMoviesRepository();

@GenerateMocks([MoviesRepository, AppNavigator, MovieListNavigator, Txt])
void main() {
  setUp(() {
    when(mockMoviesRepository.getSearchedMovies(_searchQuery_A))
        .thenAnswer((_) => Future.value(_testMovieList_A().results));
    when(mockMoviesRepository.getSearchedMovies(_searchQuery_B))
        .thenAnswer((_) => Future.value(_testMovieList_B().results));
    when(mockMoviesRepository.getSearchedMovies(_searchQueryNotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockMoviesRepository.getSearchedMovies(_searchQueryHttpErr)).thenThrow(errSearchHttp);
    when(mockMoviesRepository.getSearchedMovies(_searchQueryOtherErr)).thenThrow(errRepoOther);
    when(mockMoviesRepository.getMovie(_movieId_A2))
        .thenAnswer((_) => Future.value(_testMovieList_A().results[_movieId_A2]));
    when(mockMoviesRepository.getMovie(_movieId_B6))
        .thenAnswer((_) => Future.value(_testMovieList_B().results[_movieId_B6]));
    when(mockMoviesRepository.getMovie(_movieIdErrHttp)).thenThrow(errMovieHttp);
    when(mockMoviesRepository.getMovie(_movieIdErrOther)).thenThrow(errRepoOther);
  });

  tearDown(() {
    reset(mockMoviesRepository);
  });

  group('MovieListBloc event => state with state maintained', () {
    for (int i = 1; i < testCasesList.length; i++) {
      final prevStatesList = testCasesList[i - 1].states;
      final prevState = prevStatesList[prevStatesList.length - 1];
      final testCase = testCasesList[i];

      blocTest(
        testCase.title,
        seed: () => prevState,
        build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
        act: (bloc) => bloc.add(testCase.event),
        skip: testCase.skip,
        expect: () => testCase.states,
        verify: (_) {
          testCase.verify?.call();
        },
      );
    }
  });
}

