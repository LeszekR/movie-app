import 'package:flutter_demo/domain/entities/movie.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';

final class NavMovieDetails extends NavigationCommand<Movie> {
  NavMovieDetails(super.movie);
}

