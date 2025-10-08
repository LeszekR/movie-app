import 'package:flutter_demo/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/navigation/navigation_command.dart';
import 'package:flutter_demo/pages/movie_details/model/movie.dart';

part '../pages/movie_list/navigation/nav_commands.dart';

final class NavProgressOn extends NavigationCommand<void> {}

final class NavProgressOff extends NavigationCommand<void> {}

final class NavMovieList extends NavigationCommand<void> {}

final class NavTwoButtons extends NavigationCommand<Movie> {}

final class NavMessageDialog extends NavigationCommand<EDialogMsg> {
NavMessageDialog(super.eDialogMessage);
}

final class NavErrorDialog extends NavigationCommand<Exception> {
NavErrorDialog(super.e);
}
