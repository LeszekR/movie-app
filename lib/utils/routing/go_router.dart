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
          final String title = state.pathParameters[paramMovieTitle]!;
          final String budget = state.pathParameters[paramMovieBudget]!;
          final String revenue = state.pathParameters[paramMovieRevenue]!;
          // TODO - DI
          return MovieDetailsPage(title, budget, revenue, MovieDetailsLogic(NowInject()));
        }),
  ],
);
