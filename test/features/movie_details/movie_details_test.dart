import 'package:flutter_demo/common/config/app_config.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
import 'package:flutter_demo/features/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/features/movie_details/view/movie_details_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import 'movie_details_test.mocks.dart';

var mockAppConfig = MockAppConfig();
var mockDateTimeReader = MockDateTimeReader();
var budget = '100';
var revenue = '200';
var title = 'Avatar';

var getit = GetIt.instance;

@GenerateMocks([AppConfig, DateTimeReader])
main() {
  setUpAll(() {
    getit.registerSingleton<Txt>(Txt());
    getit.registerSingleton<AppConfig>(mockAppConfig);
    getit.registerSingleton<DateTimeReader>(mockDateTimeReader);
    getit.registerLazySingleton(() => MovieDetailsController(getit<DateTimeReader>(), getit<AppConfig>()));
  });

  tearDown(() {
    getit.reset();
  });

  testWidgets('should recommend model depending on conditions', (final WidgetTester tester) async {
    var sunday = DateTime(2025, 5, 4);
    var monday = DateTime(2025, 5, 5);
    var thresholdLow = '50';
    var thresholdHigh = '150';

    await prepareMovieDetailsWidget(tester, getit, '1', sunday);
    var txt = getit<Txt>();
    var yesString = txt.get.yes;
    var noString = txt.get.no;

    var testCaseList = [
      _MovieDetailsTestCase('high profit / Sunday', thresholdLow, sunday, yesString),
      _MovieDetailsTestCase('high profit / Monday', thresholdLow, monday, noString),
      _MovieDetailsTestCase('low profit / Sunday', thresholdHigh, sunday, noString),
      _MovieDetailsTestCase('low profit / Monday', thresholdHigh, monday, noString),
    ];

    for (var testCase in testCaseList) {
      await prepareMovieDetailsWidget(tester, getit, testCase.profitThresh, testCase.day);
      expect(find.text(testCase.expected), findsOneWidget);
    }
  });
}

Future<void> prepareMovieDetailsWidget(
  WidgetTester tester,
  GetIt getit,
  String recommendProfitThreshold,
  DateTime mockDay,
) async {
  when(mockAppConfig.param(AppConfig.recommendationProfitThreshold)).thenReturn(recommendProfitThreshold);
  when(mockDateTimeReader.now()).thenReturn(mockDay);
  await prepareWidget(tester, getit,
      widgetBuilder: () => MovieDetailsView(getit<Txt>(), title, budget, revenue, getit<MovieDetailsController>()));
}

class _MovieDetailsTestCase {
  final String title;
  final String profitThresh;
  final DateTime day;
  final String expected;

  _MovieDetailsTestCase(this.title, this.profitThresh, this.day, this.expected);
}
