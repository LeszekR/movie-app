import '../components/dialogs/e_dialog_msg.dart';
import '../features/movie_details/model/movie.dart';
import 'navigation_command.dart';

part '../features/movie_list/navigation/nav_commands.dart';

final class NavProgress extends NavigationCommand {
  NavProgress() : super();
}

final class NavMovieList extends NavigationCommand {}

final class NavTwoButtons extends NavigationCommand<Movie> {}

final class NavMessageDialog extends NavigationCommand<EDialogMsg> {
  NavMessageDialog(super.dialogParams);
}

final class NavErrorDialog extends NavigationCommand<Exception> {
  NavErrorDialog(super.e);
}
