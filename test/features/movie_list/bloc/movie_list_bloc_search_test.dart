import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/components/dialogs/dialog_factory.dart';
import 'package:flutter_demo/components/sorting/sorter.dart';
import 'package:flutter_demo/features/movie_details/model/movie.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_event.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_state.dart';
import 'package:flutter_demo/features/movie_list/model/movie_list.dart';
import 'package:flutter_demo/navigation/nav_commands_common.dart';
import 'package:flutter_demo/repositories/movies_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_search_test.mocks.dart';
import 'movie_list_bloc_test_data.dart';

@GenerateMocks([MoviesRepository])
void main() {
  MockMoviesRepository mockMoviesRepository = MockMoviesRepository();
  MovieListTestData d = MovieListTestData();

  setUp(() {
    when(mockMoviesRepository.getSearchedMovies(d.query_A)).thenAnswer((_) => Future.value(d.movieList_A().results));
    when(mockMoviesRepository.getSearchedMovies(d.query_B)).thenAnswer((_) => Future.value(d.movieList_B().results));
    when(mockMoviesRepository.getSearchedMovies(d.query_NotFound)).thenAnswer((_) => Future.value(List.empty()));
    when(mockMoviesRepository.getSearchedMovies(d.query_HttpErr)).thenThrow(d.errSearchHttp);
    when(mockMoviesRepository.getSearchedMovies(d.query_OtherErr)).thenThrow(d.errRepoOther);
  });

  tearDown(() {
    reset(mockMoviesRepository);
  });

  group('search movies - progress indicator', () {
    blocTest(
      'search show progress',
      seed: () => MovieListState(),
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_A)),
      expect: () => [
        MovieListState(
          navCommand: NavProgress(),
        ),
        MovieListState(
          movieList: d.movieList_A(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_A,
          navCommand: null,
        )
      ],
    );
  });

  group('search movies - edge cases', () {
    blocTest(
      'search query null',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(null)),
      seed: () => MovieListState(),
      expect: () => [],
      skip: 0,
      verify: (bloc) {
        verifyNever(mockMoviesRepository.getSearchedMovies(d.query_A));
      },
    );

    blocTest(
      'search query empty string',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent('')),
      seed: () => MovieListState(),
      expect: () => [],
      skip: 0,
      verify: (bloc) {
        verifyNever(mockMoviesRepository.getSearchedMovies(d.query_A));
      },
    );
  });

  group('empty list => search movies => failed', () {
    blocTest(
      'empty => search not found',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_NotFound)),
      skip: 1,
      seed: () => MovieListState(),
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_NotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_NotFound)).called(1);
      },
    );

    blocTest(
      'empty  => search http error',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_HttpErr)),
      skip: 1,
      seed: () => MovieListState(),
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_HttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_HttpErr)).called(1);
      },
    );

    blocTest(
      'empty  => search other error',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_OtherErr)),
      skip: 1,
      seed: () => MovieListState(),
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_OtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_OtherErr)).called(1);
      },
    );
  });

  group('full list => search movies => failed', () {
    blocTest(
      'full => search not found',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_NotFound)),
      seed: () => MovieListState(
        movieList: d.movieList_B(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: d.query_B,
        navCommand: null,
      ),
      skip: 1,
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_NotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_NotFound)).called(1);
      },
    );

    blocTest(
      'full => search http error',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_HttpErr)),
      skip: 1,
      seed: () => MovieListState(
        movieList: d.movieList_B(),
        selectedMovieId: MovieId.value(d.selectedId_18),
        scrollOffset: 0,
        searchQuery: d.query_B,
        navCommand: null,
      ),
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_HttpErr,
          navCommand: NavErrorDialog(d.errSearchHttp),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_HttpErr)).called(1);
      },
    );

    blocTest(
      'full => search other error',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_OtherErr)),
      skip: 1,
      seed: () => MovieListState(
        movieList: MovieList.empty(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: d.query_A,
        navCommand: NavMovieDetails(d.movieList_A().results[d.movieId_A2]),
      ),
      expect: () => [
        MovieListState(
          movieList: MovieList.empty(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_OtherErr,
          navCommand: NavErrorDialog(d.errRepoOther),
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_OtherErr)).called(1);
      },
    );
  });

  // SEARCH SUCCESSFUL
  group('search movies => successful', () {
    blocTest(
      'empty list => search => successful',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_A)),
      seed: () => MovieListState(),
      skip: 1,
      expect: () => [
        MovieListState(
          movieList: d.movieList_A(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_A,
          navCommand: null,
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_A)).called(1);
      },
    );

    blocTest(
      'full list => search => successful',
      build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>()),
      act: (bloc) => bloc.add(SearchMoviesEvent(d.query_B)),
      seed: () => MovieListState(
        movieList: d.movieList_A(),
        selectedMovieId: MovieId.value(d.movieId_A2),
        scrollOffset: d.scrollOffset_230,
        searchQuery: d.query_A,
        navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
      ),
      skip: 1,
      expect: () => [
        MovieListState(
          movieList: d.movieList_B(),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: d.query_B,
          navCommand: null,
        )
      ],
      verify: (bloc) {
        verify(mockMoviesRepository.getSearchedMovies(d.query_B)).called(1);
      },
    );
  });
}

// blocTest(
//     '',
// build: () => MovieListBloc(mockMoviesRepository, Sorter<Movie>(MovieList.empty())),
//     act: (bloc) =>  => bloc.add(...),
//     seed: () => ...,
//     skip: ...
//     expect: () => [
//     ...,
//     ],
//     verify: (bloc)
// {
//   verify(mockMoviesRepository....(...)).called(...);
// },
// );

// var tt = [
//   d.MovieListBlocTestCase(
//     title: '1 search OK',
//     event: SearchMoviesEvent(d.query_A),
//     states: [
//       MovieListState(
//         navCommand: NavProgress(),
//       ),
//       MovieListState(
//         movieList: d.movieList_A(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: null,
//       )
//     ],
//     verify: () => verify(mockMoviesRepository.getSearchedMovies(d.query_A)).called(1),
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '2 select',
//     event: SelectMovieEvent(d.selectedId_3),
//     states: [
//       MovieListState(
//         movieList: d.movieList_A(),
//         selectedMovieId: MovieId.value(d.selectedId_3),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: null,
//       )
//     ],
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '3 search OK',
//     event: SearchMoviesEvent(d.query_B),
//     states: [
//       MovieListState(
//         movieList: d.movieList_B(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       )
//     ],
//     skip: 1,
//   ),
//
//   d.MovieListBlocTestCase(
//       title: '4 search not found',
//       event: SearchMoviesEvent(d.query_NotFound),
//       states: [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: MovieId.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_NotFound,
//           navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
//         )
//       ],
//       skip: 1),
//   //
//   d.MovieListBlocTestCase(
//     title: '5 search OK',
//     event: SearchMoviesEvent(d.query_B),
//     states: [
//       MovieListState(
//         movieList: MovieList.empty(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_NotFound,
//         navCommand: NavProgress(),
//       ),
//       MovieListState(
//         movieList: d.movieList_B(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       )
//     ],
//   ),
//
//   d.MovieListBlocTestCase(
//     title: '6 select',
//     event: SelectMovieEvent(d.selectedId_18),
//     skip: 1,
//   ),
//
//   d.MovieListBlocTestCase(
//     title: '8 search OK',
//     event: SearchMoviesEvent(d.query_A),
//     states: [
//       MovieListState(
//         movieList: d.movieList_A(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: null,
//       )
//     ],
//     skip: 1,
//   ),
//
//   d.MovieListBlocTestCase(
//     title: '9 select',
//     event: SelectMovieEvent(d.selectedId_18),
//     states: [
//       MovieListState(
//         movieList: d.movieList_A(),
//         selectedMovieId: MovieId.value(d.selectedId_18),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: null,
//       )
//     ],
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '10 show movie details',
//     event: ShowMovieDetailsEvent(MovieId.value(d.movieId_A2), d.scrollOffset_8),
//     states: [
//       MovieListState(
//         movieList: d.movieList_A(),
//         selectedMovieId: MovieId.value(d.selectedId_18),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: NavProgress(),
//       ),
//     ],
//     verify: () => verify(mockMoviesRepository.getMovie(d.movieId_A2)).called(1),
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '11 search other error',
//     event: SearchMoviesEvent(d.searchQueryOtherErr),
//     skip: 1,
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '12 search OK',
//     event: SearchMoviesEvent(d.query_B),
//     states: [
//       MovieListState(
//         movieList: d.movieList_B(),
//         selectedMovieId: MovieId.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       )
//     ],
//     skip: 1,
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '13 select',
//     event: SelectMovieEvent(d.movieId_B6),
//     states: [
//       MovieListState(
//         movieList: d.movieList_B(),
//         selectedMovieId: MovieId.value(d.movieId_B6),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       )
//     ],
//   ),
//   //
//   d.MovieListBlocTestCase(
//     title: '14 show two buttons',
//     event: ShowTwoButtonsEvent(d.scrollOffset_230),
//     states: [
//       MovieListState(
//         movieList: d.movieList_B(),
//         selectedMovieId: MovieId.value(d.movieId_B6),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_B,
//         navCommand: NavTwoButtons(),
//       )
//     ],
//   ),
//   // TODO add error cases for MovieDetails
// ];
