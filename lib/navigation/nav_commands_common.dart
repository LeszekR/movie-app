import '../components/message_dialog.dart';
import '../features/movie_details/model/movie.dart';

part '../features/movie_list/navigation/nav_commands.dart';

abstract class NavigationCommand<T> {
  final T? payload;
  bool _isConsumed = false;

  NavigationCommand([this.payload]);

  bool get isConsumed => _isConsumed;

  bool consumeOnceIfActive() {
    if (_isConsumed) return false;
    _isConsumed = true;
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return isConsumed == (other as NavigationCommand).isConsumed;
  }

  @override
  int get hashCode => Object.hash(runtimeType, this);
}

final class ProgressNav extends NavigationCommand {
  ProgressNav() : super();
}

final class ErrorDialogNav extends NavigationCommand<Exception> {
  ErrorDialogNav(super.e);
}

final class MessageDialogNav extends NavigationCommand<DialogParams> {
  MessageDialogNav(super.dialogParams);
}

final class MovieListNav extends NavigationCommand {}
