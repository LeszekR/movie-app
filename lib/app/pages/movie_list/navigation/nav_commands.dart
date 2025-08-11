import '../../../../domain/entities/movie.dart';
import '../../../navigation/navigation_command.dart';

final class NavMovieDetails extends NavigationCommand<Movie> {
  NavMovieDetails(super.movie);
}

