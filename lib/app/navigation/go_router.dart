part of '../pages/movie_app/view/movie_app.dart';

GoRouter goRouter() {
  return GoRouter(
    initialLocation: pathHome,
    routes: [
      GoRoute(
        name: routeHome,
        path: pathHome,
        builder: (context, state) => const MovieListView(),
      ),
      GoRoute(
        name: routeMovieDetails,
        path: pathMovieDetails,
        builder: (context, state) {
          final String title = state.pathParameters[paramMovieTitle]!;
          final String budget = state.pathParameters[paramMovieBudget]!;
          final String revenue = state.pathParameters[paramMovieRevenue]!;
          return MovieDetailsView(title, budget, revenue);
        },
      ),
      GoRoute(
        name: routeTwoButtons,
        path: pathTwoButtons,
        builder: (context, state) => const TwoButtonsView(),
      ),
    ],
  );
}
