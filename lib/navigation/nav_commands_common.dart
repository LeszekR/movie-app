import '../components/dialogs/dialog_factory.dart';
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
  int get hashCode => Object.hash(runtimeType, payload);
  // int get hashCode => Object.hash(runtimeType, this);
}

final class NavProgress extends NavigationCommand {
  NavProgress() : super();
}

final class NavMovieList extends NavigationCommand {}

final class NavMessageDialog extends NavigationCommand<EDialogMsg> {
  NavMessageDialog(super.dialogParams);
}

final class NavErrorDialog extends NavigationCommand<Exception> {
  NavErrorDialog(super.e);
}
