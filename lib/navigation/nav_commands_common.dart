import '../components/message_dialog.dart';
import '../features/movie_details/model/movie.dart';

part '../features/movie_list/navigation/nav_commands.dart';

abstract class NavigationCommand<T> {
  final T? payload;
  const NavigationCommand() : payload = null;
  const NavigationCommand.withPayload(this.payload);
}

sealed class _NavigationCommandWithData<T> extends NavigationCommand<T> {
  const _NavigationCommandWithData(T super.payload) : super.withPayload();
}

final class ShowLoading extends NavigationCommand {
  const ShowLoading() : super();
}

final class ShowError extends _NavigationCommandWithData<Exception> {
  const ShowError(super.e);
}

final class ShowMessage extends _NavigationCommandWithData<DialogParams> {
  const ShowMessage(super.dialogParams);
}

