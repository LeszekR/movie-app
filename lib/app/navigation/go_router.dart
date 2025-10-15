part of '../pages/movie_app/view/movie_app.dart';

GoRouter goRouter() {
  return GoRouter(
    initialLocation: pathHome,
    routes: [
      GoRoute(
        name: routeHome,
        path: pathHome,
        builder: (context, state) => MovieListView(
          getIt<MovieAppController>(),
          getIt<MovieListController>(),
          getIt<MovieListNavigator>(),
        ),
      ),
      GoRoute(
        name: routeMovieDetails,
        path: pathMovieDetails,
        builder: (context, state) {
          final String title = state.pathParameters[paramMovieTitle]!;
          final String budget = state.pathParameters[paramMovieBudget]!;
          final String revenue = state.pathParameters[paramMovieRevenue]!;
          return MovieDetailsView(title, budget, revenue, getIt<MovieDetailsUtils>());
        },
      ),
      GoRoute(
        name: routeTwoButtons,
        path: pathTwoButtons,
        builder: (context, state) => TwoButtonsView(getIt<TwoButtonsController>(), getIt<TwoButtonsNavigator>()),
      ),
    ],
  );
}
