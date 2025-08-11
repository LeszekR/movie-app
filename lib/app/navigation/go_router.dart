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
    ],
  );
}
