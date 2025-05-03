// TODO consider replacing this with `Clock` package and mock date in tests with it

/* Allows for mocking time in tests */
class NowInject {
  DateTime now() => DateTime.now();
}
