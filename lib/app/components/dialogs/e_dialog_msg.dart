enum EDialogMsg {
  searchQueryNotFound,
  noMovieSelected,
  noSuchMovie,
}

// enum EDialogMessage {
//   searchQueryNotFound,
//   noMovieSelected,
//   noSuchMovie;
//
//   static EDialogMessage from(String eDialogMsgName) {
//     return EDialogMessage.values.firstWhere(
//           (e) => e.name == eDialogMsgName,
//       orElse: () => throw Exception('EDialogMsg found no value for: $eDialogMsgName'),
//     );
//   }
// }
//
