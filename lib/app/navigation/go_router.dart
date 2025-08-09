part of '../../movie_app.dart';

GoRouter goRouter() {
  return GoRouter(
    initialLocation: pathHome,
    routes: [
      GoRoute(
        name: routeHome,
        path: pathHome,
        builder: (context, state) => MovieListView(),
      ),
      GoRoute(
          name: routeMovieDetails,
          path: pathMovieDetails,
          builder: (context, state) {
            final String title = state.pathParameters[paramMovieTitle]!;
            final String budget = state.pathParameters[paramMovieBudget]!;
            final String revenue = state.pathParameters[paramMovieRevenue]!;
            return MovieDetailsView(title, budget, revenue);
          }),
      GoRoute(
          name: routeMessageDialog,
          path: pathMessageDialog,
          builder: (context, state) {
            final String eDialogMsgName = state.pathParameters[paramEDialogMsgName]!;
            return getit<DialogFactory>().message(eDialogMsgName);
          }),
      GoRoute(
          name: routeErrorDialog,
          path: pathErrorDialog,
          builder: (context, state) {
            final String eDialogMsgName = state.pathParameters[paramEDialogMsgName]!;
            // TU PRZERWAŁEM - obsłużyć przekazanie exceptions do dialogu poprzez String param dla GoRouter
            return getit<DialogFactory>().error(eDialogMsgName);
          }),
    ],
  );
}
