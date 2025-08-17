import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';
import 'state_comparator.dart';

/// Tested `Controller` must hold its state in an `Object`. If the state encompasses only one variable then for
/// `controllerTest` to work it must be wrapped with a state-class anyway and provided by getIt
/// `skip`: number of `States` to ignore before verifying the state important for the test - if set to more than 0
/// then also `asyncTicks` must be provided
/// `asyncTicks`: total number of: Futures, onNext(...) calls, other async calls - between each two states of the
/// controller
void controllerTest<C extends Controller, T extends Object>(
  String description, {
  void Function()? setMocks,
  required T Function() seed,
  required C Function() build,
  required void Function(C) act,
  required List<T> Function() expect,
  int skip = 0,
  int asyncTicks = 0,
  void Function()? verify,
}) {
  test(description, () async {
    print('${"=" * 40}\n$description');

    getItReplaceLazySingleton<T>(() => seed());

    setMocks?.call();

    final C controller = build();

    await () async {
      act(controller);

      // TODO refactor to logging to console instead of print()
      print('==> expect functions');

      var expectedStates = expect();
      for (int i = 0; i < expectedStates.length; i++) {
        if (i >= skip) {
          stateExpect(controller, expectedStates[i]);
        }

        // Schedules a callback in the next microtask or event loop tick to yield control back to Dart's async
        // event loop, allowing any pending Futures, Streams, or Controller state transitions to complete.
        for (int i = 0; i < asyncTicks; i++) {
          await Future.delayed(Duration.zero);
        }
      }
    }();

    // TODO refactor to logging to console instead of print()
    print('==> verify functions');
    verify?.call();
  });
}
