// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_demo/components/dialogs/e_dialog_msg.dart';
// import 'package:flutter_demo/pages/movie_list/controller/movie_list_event.dart';
// import 'package:flutter_demo/pages/movie_list/controller/movie_list_state.dart';
// import 'package:flutter_demo/pages/movie_list/model/movie_list.dart';
// import 'package:flutter_demo/navigation/app_nav_commands.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// import '../../../test_tools/mocks/common_mocks.mocks.dart';
// import 'movie_list_controller_test_data.dart';
//
// void main() {
//   MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
//   MovieListTestData d = MovieListTestData();
//
//   setUp(() {
//     when(mockDataMovieRepository.getSearchedMovies(d.query_A)).thenAnswer((_) => Future.value(d.movieList_A.results));
//     when(mockDataMovieRepository.getSearchedMovies(d.query_B)).thenAnswer((_) => Future.value(d.movieList_B.results));
//     when(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).thenAnswer((_) => Future.value(List.empty()));
//     when(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).thenThrow(d.errSearchHttp);
//     when(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).thenThrow(d.errRepoOther);
//   });
//
//   tearDown(() {
//     reset(mockDataMovieRepository);
//   });
//
//   group('search movies - progress indicator', () {
//     blocTest(
//       'search show progress',
//       seed: () => MovieListState(),
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_A)),
//       expect: () => [
//         MovieListState(
//           navCommand: NavProgressOn(),
//         ),
//         MovieListState(
//           movieList: d.movieList_A,
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_A,
//           navCommand: NavProgressOff(),
//         )
//       ],
//     );
//   });
//
//   group('search movies - edge cases', () {
//     blocTest(
//       'search query null',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(null)),
//       seed: () => MovieListState(),
//       expect: () => [],
//       skip: 0,
//       verify: (bloc) {
//         verifyNever(mockDataMovieRepository.getSearchedMovies(d.query_A));
//       },
//     );
//
//     blocTest(
//       'search query empty string',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent('')),
//       seed: () => MovieListState(),
//       expect: () => [],
//       skip: 0,
//       verify: (bloc) {
//         verifyNever(mockDataMovieRepository.getSearchedMovies(any));
//       },
//     );
//   });
//
//   group('empty list => search movies => failed', () {
//     blocTest(
//       'empty => search not found',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_NotFound)),
//       skip: 1,
//       seed: () => MovieListState(),
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_NotFound,
//           navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).called(1);
//       },
//     );
//
//     blocTest(
//       'empty  => search http error',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_HttpErr)),
//       skip: 1,
//       seed: () => MovieListState(),
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_HttpErr,
//           navCommand: NavErrorDialog(d.errSearchHttp),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).called(1);
//       },
//     );
//
//     blocTest(
//       'empty  => search other error',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_OtherErr)),
//       skip: 1,
//       seed: () => MovieListState(),
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_OtherErr,
//           navCommand: NavErrorDialog(d.errRepoOther),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).called(1);
//       },
//     );
//   });
//
//   group('full list => search movies => failed', () {
//     blocTest(
//       'full => search not found',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_NotFound)),
//       seed: () => MovieListState(
//         movieList: d.movieList_B,
//         selectedMovieId: ThreeStateInt.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       ),
//       skip: 1,
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_NotFound,
//           navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_NotFound)).called(1);
//       },
//     );
//
//     blocTest(
//       'full => search http error',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_HttpErr)),
//       skip: 1,
//       seed: () => MovieListState(
//         movieList: d.movieList_B,
//         selectedMovieId: ThreeStateInt.value(d.selectedId_18),
//         scrollOffset: 0,
//         searchQuery: d.query_B,
//         navCommand: null,
//       ),
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_HttpErr,
//           navCommand: NavErrorDialog(d.errSearchHttp),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_HttpErr)).called(1);
//       },
//     );
//
//     blocTest(
//       'full => search other error',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_OtherErr)),
//       skip: 1,
//       seed: () => MovieListState(
//         movieList: MovieList.empty(),
//         selectedMovieId: ThreeStateInt.none(),
//         scrollOffset: 0,
//         searchQuery: d.query_A,
//         navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
//       ),
//       expect: () => [
//         MovieListState(
//           movieList: MovieList.empty(),
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_OtherErr,
//           navCommand: NavErrorDialog(d.errRepoOther),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_OtherErr)).called(1);
//       },
//     );
//   });
//
//   // SEARCH SUCCESSFUL
//   group('search movies => successful', () {
//     blocTest(
//       'empty list => search => successful',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_A)),
//       seed: () => MovieListState(),
//       skip: 1,
//       expect: () => [
//         MovieListState(
//           movieList: d.movieList_A,
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_A,
//           navCommand: NavProgressOff(),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_A)).called(1);
//       },
//     );
//
//     blocTest(
//       'full list => search => successful',
//       build: () => d.makeMovieListBloc(mockDataMovieRepository),
//       act: (bloc) => bloc.add(SearchMoviesEvent(d.query_B)),
//       seed: () => MovieListState(
//         movieList: d.movieList_A,
//         selectedMovieId: ThreeStateInt.value(d.movieId_A2),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_A,
//         navCommand: NavMessageDialog(EDialogMsg.searchQueryNotFound),
//       ),
//       skip: 1,
//       expect: () => [
//         MovieListState(
//           movieList: d.movieList_B,
//           selectedMovieId: ThreeStateInt.none(),
//           scrollOffset: 0,
//           searchQuery: d.query_B,
//           navCommand: NavProgressOff(),
//         )
//       ],
//       verify: (bloc) {
//         verify(mockDataMovieRepository.getSearchedMovies(d.query_B)).called(1);
//       },
//     );
//   });
// }
//
