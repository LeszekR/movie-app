import '../../../../domain/entities/movie.dart';
import '../../../navigation/nav_commands_common.dart';

final class NavMovieDetails extends NavigationCommand<Movie> {
  NavMovieDetails(super.movie);
}

