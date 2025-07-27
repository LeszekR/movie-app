import '../components/message_dialog.dart';
import '../features/movie_details/model/movie.dart';

part '../features/movie_list/navigation/nav_commands.dart';

abstract class NavigationCommand<T> {
  final T? payload;
  bool _isConsumed = false;

  NavigationCommand() : payload = null;

  NavigationCommand.withPayload(this.payload);

  bool get isConsumed {
    if (_isConsumed) return true;
    _isConsumed = true;
    return false;
  }
}

sealed class _NavigationCommandWithData<T> extends NavigationCommand<T> {
  _NavigationCommandWithData(T super.payload) : super.withPayload();
}

final class ShowLoading extends NavigationCommand {
  ShowLoading() : super();
}

final class ShowError extends _NavigationCommandWithData<Exception> {
  ShowError(super.e);
}

final class ShowMessage extends _NavigationCommandWithData<DialogParams> {
  ShowMessage(super.dialogParams);
}

final class ShowMovieList extends NavigationCommand {}
