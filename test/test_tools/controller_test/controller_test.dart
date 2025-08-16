import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'state_comparator.dart';

void controllerTest<C extends Controller, T extends Object>(
  String description, {
  required T Function() seed,
  required C Function() build,
  required void Function(C) act,
  required List<T> Function() expect,
  void Function()? verify,
}) {
  test(description, () {
    if (getIt.isRegistered<T>()) getIt.unregister<T>();
    getIt.registerLazySingleton<T>(() => seed());

    final C controller = build();

    act(controller);

    // TODO refactor to logging to console instead of print()
    print('==> expect functions');
    for (var expectElement in expect.call()) {
      stateComparator(controller, expectElement);
    }

    // TODO refactor to logging to console instead of print()
    print('==> verify functions');
    verify?.call();
  });
}

class ControllerTestExpect<C extends Controller, T> {
  final T actualState;
  final T expectedState;

  const ControllerTestExpect(this.actualState, this.expectedState);
}
