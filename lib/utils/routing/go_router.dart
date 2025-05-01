part of '../../movie_app.dart';

final _router = GoRouter(
  initialLocation: pathHome,
  routes: [
    GoRoute(
      name: routeHome,
      path: pathHome,
      // TODO - DI
      builder: (context, state) => MovieListPage(apiService: ApiService()),
    ),
    GoRoute(
        name: routeMovieDetails,
        path: pathMovieDetails,
        builder: (context, state) {
          final String budget = state.pathParameters[paramMovieBudget]!;
          final String revenue = state.pathParameters[paramMovieRevenue]!;
          return MovieDetailsPage(budget, revenue);
        }),
  ],
);
