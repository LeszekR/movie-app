/* Allows for mocking time in tests */
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_time_reader.g.dart';

// TODO consider replacing this with `Clock` package and mock date in tests with it

@riverpod
class DateTimeReader extends _$DateTimeReader {
  DateTime now() => DateTime.now();

  @override
  DateTimeReader build() => DateTimeReader();
}
