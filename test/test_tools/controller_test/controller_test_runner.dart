import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';
import 'state_comparator.dart';

/// A reusable test helper inspired by `blocTest`, adapted for testing Clean Architecture `Controller`s.
///
/// Runs a complete test cycle: seed state, build controller, perform action, expect emitted states, and verify mocks.
///
/// **Notes:**
/// - The tested `Controller` must expose its state as a full object of type `T`.
/// - If your controller's state consists of just one value (e.g. `int`, `bool`), you still need to wrap it in a state class and register it in `getIt`.
///
/// **Parameters:**
/// - `description`: Name of the test.
/// - `seed`: Provides the initial state object to be registered in `getIt`.
/// - `build`: Creates a new controller instance.
/// - `act`: Performs the action on the controller (e.g. `controller.fetchData()`).
/// - `expect`: Returns the list of expected controller states (in order).
/// - `skip`: Skips the first `n` emitted states. Useful if the test only cares about state changes after a given point.
/// - `asyncTicks`: The number of event-loop ticks (microtask flushes) to wait between each state check.
///   - Use this if the controller has multiple asynchronous operations (e.g., API call → log → update state).
///   - One tick (`Future.delayed(Duration.zero)`) is usually enough, but increase this when needed.
/// - `setMocks`: Optional setup function to prepare mock behaviors.
/// - `verify`: Optional function to verify mock invocations.
///
/// Example usage:
/// ```dart
/// controllerTest<MyController, MyState>(
///   'loads and displays data',
///   seed: () => MyState.initial(),
///   build: () => MyController(),
///   act: (controller) => controller.loadData(),
///   expect: () => [
///     MyState.loading(),
///     MyState.success(data),
///   ],
///   verify: () {
///     verify(mockRepo.fetchData()).called(1);
///   },
/// );
/// ```
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

    print('==> verify functions');
    verify?.call();
  });
}
