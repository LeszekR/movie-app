import '../features/movie_details/model/movie.dart';

part '../features/movie_list/navigation/nav_commands.dart';

enum ENavCommand {
  loading,
  errorDialog,
  infoDialog,
  movieDetails,
}

abstract class NavigationCommand<T> {
  final ENavCommand command;
  final T? payload;
  const NavigationCommand(this.command) : payload = null;
  const NavigationCommand.withPayload(this.command, this.payload);
}

sealed class _NavigationCommandWithData<T> extends NavigationCommand<T> {
  const _NavigationCommandWithData(super.command, T super.payload) : super.withPayload();
}

final class ShowLoading extends NavigationCommand {
  const ShowLoading() : super(ENavCommand.loading);
}

final class ShowError extends _NavigationCommandWithData<Exception> {
  const ShowError(Exception e) : super(ENavCommand.errorDialog, e);
}

final class ShowDialog extends _NavigationCommandWithData<String> {
  const ShowDialog(String text) : super(ENavCommand.infoDialog, text);
}
