part of '../../../navigation/nav_commands_common.dart';

final class ShowMovieDetails extends _NavigationCommandWithData<Movie> {
  const ShowMovieDetails(Movie movie) : super(ENavCommand.movieDetails, movie);
}
