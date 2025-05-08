import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_time_reader.g.dart';

// TODO consider replacing this with `Clock` package and mock date in tests with it
/*
This class for all other purposes is unnecessary except it makes it possible to mock time in tests. .
 */
@riverpod
DateTimeReader dateTimeReader(Ref ref) => DateTimeReader();

class DateTimeReader {
  DateTime now() => DateTime.now();
}
