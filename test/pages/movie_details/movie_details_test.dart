import 'package:flutter_recruitment_task/app/pages/movie_details/movie_details_view.dart';
import 'package:flutter_recruitment_task/data/config/app_config.dart';
import 'package:flutter_recruitment_task/domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'package:flutter_recruitment_task/domain/utils/date_time_reader/date_time_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import 'movie_details_test.mocks.dart';

var mockAppConfig = MockAppConfig();
var mockDateTimeReader = MockDateTimeReader();
var budget = '100';
var revenue = '200';
var title = 'Avatar';

@GenerateMocks([AppConfig, DateTimeReader])
main() {
  testWidgets('should recommend movie depending on conditions', (final WidgetTester tester) async {
    var sunday = DateTime(2025, 5, 4);
    var monday = DateTime(2025, 5, 5);
    var thresholdLow = '50';
    var thresholdHigh = '150';

    await prepareMovieDetailsWidget(tester, '1', sunday);
    var yesString = Txt.get.yes;
    var noString = Txt.get.no;

    var testCaseList = [
      _MovieDetailsTestCase('high profit / Sunday', thresholdLow, sunday, yesString),
      _MovieDetailsTestCase('high profit / Monday', thresholdLow, monday, noString),
      _MovieDetailsTestCase('low profit / Sunday', thresholdHigh, sunday, noString),
      _MovieDetailsTestCase('low profit / Monday', thresholdHigh, monday, noString),
    ];

    for (var testCase in testCaseList) {
      await prepareMovieDetailsWidget(tester, testCase.profitThresh, testCase.day);
      expect(find.text(testCase.expected), findsOneWidget);
    }
  });
}

Future<void> prepareMovieDetailsWidget(WidgetTester tester, String recommendProfitThreshold, DateTime mockDay) async {
  when(mockAppConfig.param(AppConfig.recommendationProfitThreshold)).thenReturn(recommendProfitThreshold);
  when(mockDateTimeReader.now()).thenReturn(mockDay);
  //
  await prepareWidget(tester, widgetBuilder: () => MovieDetailsView(title, budget, revenue), overrides: [
    appConfigProvider.overrideWith((ref) => mockAppConfig),
    dateTimeReaderProvider.overrideWith((ref) => mockDateTimeReader),
  ]);
}

class _MovieDetailsTestCase {
  final String title;
  final String profitThresh;
  final DateTime day;
  final String expected;

  _MovieDetailsTestCase(this.title, this.profitThresh, this.day, this.expected);
}
