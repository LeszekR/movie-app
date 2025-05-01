class NowInject {
  DateTime now() => DateTime.now();

  int lastWeekday = 1;

  int weekday() {

  // TODO remove this debug implementation after writing proper mocked test of movie recommendation depending on weekday
    lastWeekday = lastWeekday == 7 ? 1 : 7;
    return lastWeekday;

    return DateTime.now().weekday;
  }
}
