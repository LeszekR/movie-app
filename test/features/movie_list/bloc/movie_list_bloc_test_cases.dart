part of 'movie_list_bloc_test.dart';

var testCasesList = [
  _MovieListBlocTestCase(
    title: '=> THIS CASE SHOULD NOT BE RUN! it only contains seed for the first case',
    event: SearchMoviesEvent(''),
    states: [MovieListState()],
  ),
  //
  _MovieListBlocTestCase(
    title: '1 search OK',
    event: SearchMoviesEvent(_searchQuery_A),
    states: [
      MovieListState(
        navCommand: NavProgress(),
      ),
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQuery_A,
        navCommand: null,
      )
    ],
    verify: () => verify(mockMoviesRepository.getSearchedMovies(_searchQuery_A)).called(1),
  ),
  //
  _MovieListBlocTestCase(
    title: '2 select',
    event: SelectMovieEvent(_selectedId_3),
    states: [
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.value(_selectedId_3),
        scrollOffset: 0,
        searchQuery: _searchQuery_A,
        navCommand: null,
      )
    ],
  ),
  //
  _MovieListBlocTestCase(
    title: '3 search OK',
    event: SearchMoviesEvent(_searchQuery_B),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQuery_B,
        navCommand: null,
      )
    ],
    skip: 1,
  ),

  _MovieListBlocTestCase(
      title: '4 search not found',
      event: SearchMoviesEvent(_searchQueryNotFound),
      states: [
        MovieListState(
          movieList: MovieList(totalResults: 0, results: []),
          selectedMovieId: MovieId.none(),
          scrollOffset: 0,
          searchQuery: _searchQueryNotFound,
          navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
        )
      ],
      skip: 1),
  //
  _MovieListBlocTestCase(
    title: '5 search OK',
    event: SearchMoviesEvent(_searchQuery_B),
    states: [
      MovieListState(
        movieList: MovieList(totalResults: 0, results: []),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQueryNotFound,
        navCommand: NavProgress(),
      ),
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQuery_B,
        navCommand: null,
      )
    ],
  ),

  _MovieListBlocTestCase(
    title: '6 select',
    event: SelectMovieEvent(_selectedId_18),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.value(_selectedId_18),
        scrollOffset: 0,
        searchQuery: _searchQuery_B,
        navCommand: null,
      )
    ],
  ),
  //
  _MovieListBlocTestCase(
    title: '7 search other error',
    event: SearchMoviesEvent(_searchQueryHttpErr),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.value(_selectedId_18),
        scrollOffset: 0,
        searchQuery: _searchQueryHttpErr,
        navCommand: NavErrorDialog(errSearchHttp),
      )
    ],
    skip: 1,
  ),

  _MovieListBlocTestCase(
    title: '8 search OK',
    event: SearchMoviesEvent(_searchQuery_A),
    states: [
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQuery_A,
        navCommand: null,
      )
    ],
    skip: 1,
  ),

  _MovieListBlocTestCase(
    title: '9 select',
    event: SelectMovieEvent(_selectedId_18),
    states: [
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.value(_selectedId_18),
        scrollOffset: 0,
        searchQuery: _searchQuery_A,
        navCommand: null,
      )
    ],
  ),
  //
  _MovieListBlocTestCase(
    title: '10 show movie details',
    event: ShowMovieDetailsEvent(MovieId.value(_movieId_A2), _scrollOffset_8),
    states: [
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.value(_selectedId_18),
        scrollOffset: 0,
        searchQuery: _searchQuery_A,
        navCommand: NavProgress(),
      ),
      MovieListState(
          movieList: _testMovieList_A(),
          selectedMovieId: MovieId.value(_movieId_A2),
          scrollOffset: _scrollOffset_8,
          searchQuery: _searchQuery_A,
          navCommand: NavMovieDetails(_testMovieList_A().results[_movieId_A2])),
    ],
    verify: () => verify(mockMoviesRepository.getMovie(_movieId_A2)).called(1),
  ),
  //
  _MovieListBlocTestCase(
    title: '11 search other error',
    event: SearchMoviesEvent(_searchQueryOtherErr),
    states: [
      MovieListState(
        movieList: _testMovieList_A(),
        selectedMovieId: MovieId.value(_movieId_A2),
        scrollOffset: _scrollOffset_8,
        searchQuery: _searchQueryOtherErr,
        navCommand: NavErrorDialog(errRepoOther),
      )
    ],
    skip: 1,
  ),
  //
  _MovieListBlocTestCase(
    title: '12 search OK',
    event: SearchMoviesEvent(_searchQuery_B),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.none(),
        scrollOffset: 0,
        searchQuery: _searchQuery_B,
        navCommand: null,
      )
    ],
    skip: 1,
  ),
  //
  _MovieListBlocTestCase(
    title: '13 select',
    event: SelectMovieEvent(_movieId_B6),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.value(_movieId_B6),
        scrollOffset: 0,
        searchQuery: _searchQuery_B,
        navCommand: null,
      )
    ],
  ),
  //
  _MovieListBlocTestCase(
    title: '14 show two buttons',
    event: ShowTwoButtonsEvent(_scrollOffset_230),
    states: [
      MovieListState(
        movieList: _testMovieList_B(),
        selectedMovieId: MovieId.value(_movieId_B6),
        scrollOffset: _scrollOffset_230,
        searchQuery: _searchQuery_B,
        navCommand: NavTwoButtons(),
      )
    ],
  ),
];
