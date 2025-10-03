import 'package:flutter_demo/app/components/dialogs/e_dialog_msg.dart';
import 'package:flutter_demo/app/navigation/navigation_command.dart';
import 'package:flutter_demo/domain/entities/movie.dart';

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
