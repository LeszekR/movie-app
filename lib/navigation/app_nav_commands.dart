import '../components/dialogs/e_dialog_msg.dart';
import '../pages/movie_details/model/movie.dart';
import 'navigation_command.dart';

part '../pages/movie_list/navigation/nav_commands.dart';

final class NavProgressOn extends NavigationCommand {}

final class NavProgressOff extends NavigationCommand {}

final class NavMovieList extends NavigationCommand {}

final class NavTwoButtons extends NavigationCommand<Movie> {}

final class NavMessageDialog extends NavigationCommand<EDialogMsg> {
NavMessageDialog(super.eDialogMessage);
}

final class NavErrorDialog extends NavigationCommand<Exception> {
NavErrorDialog(super.e);
}
