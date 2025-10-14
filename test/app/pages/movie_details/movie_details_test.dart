import 'dart:ui';

import 'package:flutter_demo/app/pages/movie_details/utils/movie_details_utils.dart';
import 'package:flutter_demo/app/pages/movie_details/view/movie_details_view.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools/mocks/common_mocks.mocks.dart';
import '../../../test_tools/test_utils.dart';

MockAppParams mockAppConfig = MockAppParams();
MockDateTimeReader mockDateTimeReader = MockDateTimeReader();
String budget = '100';
String revenue = '200';
String title = 'Avatar';

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    getIt.registerSingleton<AppParams>(mockAppConfig);
    getIt.registerSingleton<DateTimeReader>(mockDateTimeReader);
    getIt.registerLazySingleton(MovieDetailsUtils.new);
  });

  tearDown(getIt.reset);

  testWidgets('should recommend movie depending on conditions', (WidgetTester tester) async {
    final sunday = DateTime(2025, 5, 4);
    final monday = DateTime(2025, 5, 5);
    const thresholdLow = '50';
    const thresholdHigh = '150';
    const language = 'pl';

    await prepareMovieDetailsWidget(tester, language, '1', sunday);
    final l10n = await AppLocalizations.delegate.load(const Locale(language));
    final yesString = l10n.yes;
    final noString = l10n.no;

    final testCaseList = [
      _MovieDetailsTestCase('high profit / Sunday', thresholdLow, sunday, yesString),
      _MovieDetailsTestCase('high profit / Monday', thresholdLow, monday, noString),
      _MovieDetailsTestCase('low profit / Sunday', thresholdHigh, sunday, noString),
      _MovieDetailsTestCase('low profit / Monday', thresholdHigh, monday, noString),
    ];

    for (final testCase in testCaseList) {
      await prepareMovieDetailsWidget(tester, language, testCase.profitThresh, testCase.day);
      expect(find.text(testCase.expected), findsOneWidget);
    }
  });
}

Future<void> prepareMovieDetailsWidget(
  WidgetTester tester,
  String language,
  String recommendProfitThreshold,
  DateTime mockDay,
) async {
  when(mockAppConfig.param(AppParams.recommendationProfitThreshold)).thenReturn(recommendProfitThreshold);
  when(mockDateTimeReader.now()).thenReturn(mockDay);
  await prepareWidget(tester, language: language, widgetBuilder: () => MovieDetailsView(title, budget, revenue));
}

class _MovieDetailsTestCase {
  final String title;
  final String profitThresh;
  final DateTime day;
  final String expected;

  _MovieDetailsTestCase(this.title, this.profitThresh, this.day, this.expected);
}
