import '../../domain/entities/movie.dart';
import '../components/dialogs/e_dialog_msg.dart';

abstract class NavigationCommand<T> {
  final T? payload;
  bool _isConsumed = false;

  NavigationCommand([this.payload]);

  bool get isConsumed => _isConsumed;

  bool consumeOnce() {
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

final class NavTwoButtons extends NavigationCommand<Movie> {}

final class NavMessageDialog extends NavigationCommand<EDialogMsg> {
  NavMessageDialog(super.eDialogMessage);
}

final class NavErrorDialog extends NavigationCommand<Exception> {
  NavErrorDialog(super.e);
}

