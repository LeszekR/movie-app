import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/ui_localized_texts/provider/txt.dart';
import 'package:flutter_recruitment_task/utils/app_config/app_config.dart';
import 'package:flutter_recruitment_task/utils/date_time_reader/date_time_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import 'movie_details_test.mocks.dart';

MockAppConfig mockAppConfig = MockAppConfig();
MockDateTimeReader mockDateTimeReader = MockDateTimeReader();
String budget = '100';
String revenue = '200';
String title = 'Avatar';

@GenerateMocks([AppConfig, DateTimeReader])
void main() {
  testWidgets('should recommend movie depending on conditions', (WidgetTester tester) async {
    final sunday = DateTime(2025, 5, 4);
    final monday = DateTime(2025, 5, 5);
    const thresholdLow = '50';
    const thresholdHigh = '150';

    await prepareMovieDetailsWidget(tester, '1', sunday);
    final yesString = Txt.get.yes;
    final noString = Txt.get.no;

    final testCaseList = [
      _MovieDetailsTestCase('high profit / Sunday', thresholdLow, sunday, yesString),
      _MovieDetailsTestCase('high profit / Monday', thresholdLow, monday, noString),
      _MovieDetailsTestCase('low profit / Sunday', thresholdHigh, sunday, noString),
      _MovieDetailsTestCase('low profit / Monday', thresholdHigh, monday, noString),
    ];

    for (final testCase in testCaseList) {
      await prepareMovieDetailsWidget(tester, testCase.profitThresh, testCase.day);
      expect(find.text(testCase.expected), findsOneWidget);
    }
  });
}

Future<void> prepareMovieDetailsWidget(WidgetTester tester, String recommendProfitThreshold, DateTime mockDay) async {
  when(mockAppConfig.param(AppConfig.recommendationProfitThreshold)).thenReturn(recommendProfitThreshold);
  when(mockDateTimeReader.now()).thenReturn(mockDay);
  //
  await prepareWidget(
    tester,
    widgetBuilder: () => MovieDetailsPage(title, budget, revenue),
    overrides: [
      appConfigProvider.overrideWith((ref) => mockAppConfig),
      dateTimeReaderProvider.overrideWith((ref) => mockDateTimeReader),
    ],
  );
}

class _MovieDetailsTestCase {
  final String title;
  final String profitThresh;
  final DateTime day;
  final String expected;

  _MovieDetailsTestCase(this.title, this.profitThresh, this.day, this.expected);
}
