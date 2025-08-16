// import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
// import 'package:flutter_demo/app/components/three_state_value.dart';
// import 'package:flutter_demo/app/navigation/app_nav_commands.dart';
// import 'package:flutter_demo/app/pages/movie_list/controller/movie_list_state.dart';
// import 'package:flutter_demo/app/pages/movie_list/navigation/nav_commands.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// import '../../../../test_tools/mocks/common_mocks.mocks.dart';
// import 'movie_list_controller_test_data.dart';
//
// void main() {
//   MockDataMovieRepository mockDataMovieRepository = MockDataMovieRepository();
//   MovieListTestData d = MovieListTestData();
//
//   setUp(() {
//     when(mockDataMovieRepository.getMovie(d.movieId_A2))
//         .thenAnswer((_) => Future.value(d.movieList_A.results[d.movieId_A2]));
//     when(mockDataMovieRepository.getMovie(d.movieId_B3))
//         .thenAnswer((_) => Future.value(d.movieList_B.results[d.movieId_B3]));
//     when(mockDataMovieRepository.getMovie(d.movieId_ErrHttp)).thenThrow(d.errMovieHttp);
//     when(mockDataMovieRepository.getMovie(d.movieId_ErrOther)).thenThrow(d.errRepoOther);
//   });
//
//   tearDown(() {
//     reset(mockDataMovieRepository);
//   });
//
//   blocTest(
//     'show movie details => show progress',
//     build: () => d.makeMovieListBloc(mockDataMovieRepository),
//     seed: () => MovieListState(
//       movieList: d.movieList_A,
//       selectedMovieId: ThreeStateInt.value(d.movieId_A2),
//       scrollOffset: d.scrollOffset_230,
//       searchQuery: d.query_A,
//       navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
//     ),
//     act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
//     expect: () => [
//       MovieListState(
//         movieList: d.movieList_A,
//         selectedMovieId: ThreeStateInt.value(d.movieId_A2),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_A,
//         navCommand: NavProgressOn(),
//       ),
//       MovieListState(
//         movieList: d.movieList_A,
//         selectedMovieId: ThreeStateInt.value(d.movieId_A2),
//         scrollOffset: d.scrollOffset_8,
//         searchQuery: d.query_A,
//         navCommand: NavMovieDetails(d.movieList_A.results[d.movieId_A2]),
//       )
//     ],
//     verify: (bloc) {
//       verify(mockDataMovieRepository.getMovie(d.movieId_A2)).called(1);
//     },
//   );
//
//   blocTest(
//     'show movie details => none selected',
//     build: () => d.makeMovieListBloc(mockDataMovieRepository),
//     seed: () => MovieListState(
//       movieList: d.movieList_B,
//       selectedMovieId: ThreeStateInt.none(),
//       scrollOffset: d.scrollOffset_230,
//       searchQuery: d.query_B,
//       navCommand: null,
//     ),
//     act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_8)),
//     expect: () => [
//       MovieListState(
//         movieList: d.movieList_B,
//         selectedMovieId: ThreeStateInt.none(),
//         scrollOffset: d.scrollOffset_8,
//         searchQuery: d.query_B,
//         navCommand: NavMessageDialog(EDialogMsg.noMovieSelected),
//       ),
//     ],
//     skip: 0,
//     verify: (bloc) {
//       verifyNever(mockDataMovieRepository.getMovie(any));
//     },
//   );
//
//   blocTest(
//     'show movie details => http error',
//     build: () => d.makeMovieListBloc(mockDataMovieRepository),
//     seed: () => MovieListState(
//       movieList: d.movieList_B,
//       selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
//       scrollOffset: d.scrollOffset_8,
//       searchQuery: d.query_B,
//       navCommand: null,
//     ),
//     act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
//     expect: () => [
//       MovieListState(
//         movieList: d.movieList_B,
//         selectedMovieId: ThreeStateInt.value(d.movieId_ErrHttp),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_B,
//         navCommand: NavErrorDialog(d.errMovieHttp),
//       ),
//     ],
//     skip: 1,
//     verify: (bloc) {
//       verify(mockDataMovieRepository.getMovie(d.movieId_ErrHttp)).called(1);
//     },
//   );
//
//   blocTest(
//     'show movie details => other error',
//     build: () => d.makeMovieListBloc(mockDataMovieRepository),
//     seed: () => MovieListState(
//       movieList: d.movieList_A,
//       selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
//       scrollOffset: d.scrollOffset_230,
//       searchQuery: d.query_A,
//       navCommand: null,
//     ),
//     act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
//     expect: () => [
//       MovieListState(
//         movieList: d.movieList_A,
//         selectedMovieId: ThreeStateInt.value(d.movieId_ErrOther),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_A,
//         navCommand: NavErrorDialog(d.errRepoOther),
//       ),
//     ],
//     skip: 1,
//     verify: (bloc) {
//       verify(mockDataMovieRepository.getMovie(d.movieId_ErrOther)).called(1);
//     },
//   );
//
//   blocTest(
//     'show movie details => success',
//     build: () => d.makeMovieListBloc(mockDataMovieRepository),
//     seed: () => MovieListState(
//       movieList: d.movieList_B,
//       selectedMovieId: ThreeStateInt.value(d.movieId_B3),
//       scrollOffset: d.scrollOffset_8,
//       searchQuery: d.query_B,
//       navCommand: null,
//     ),
//     act: (bloc) => bloc.add(ShowMovieDetailsEvent(d.scrollOffset_230)),
//     expect: () => [
//       MovieListState(
//         movieList: d.movieList_B,
//         selectedMovieId: ThreeStateInt.value(d.movieId_B3),
//         scrollOffset: d.scrollOffset_230,
//         searchQuery: d.query_B,
//         navCommand: NavMovieDetails(d.movieList_B.results[d.movieId_B3]),
//       ),
//     ],
//     skip: 1,
//     verify: (bloc) {
//       verify(mockDataMovieRepository.getMovie(d.movieId_B3)).called(1);
//     },
//   );
// }
