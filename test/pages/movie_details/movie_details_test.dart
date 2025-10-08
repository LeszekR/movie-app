import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_demo/common/utils/date_time_reader.dart';
import 'package:flutter_demo/pages/movie_details/utils/movie_details_controller.dart';
import 'package:flutter_demo/pages/movie_details/view/movie_details_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../test_tools/mocks/common_mocks.mocks.dart';
import '../../test_tools/test_utils.dart';

MockAppParams mockAppParams = MockAppParams();
MockDateTimeReader mockDateTimeReader = MockDateTimeReader();
String budget = '100';
String revenue = '200';
String title = 'Avatar';


void main() {
  setUpAll(() {
    getIt.registerSingleton<Txt>(Txt());
    getIt.registerSingleton<AppParams>(mockAppParams);
    getIt.registerSingleton<DateTimeReader>(mockDateTimeReader);
    getIt.registerLazySingleton(() => MovieDetailsController(getIt<DateTimeReader>(), getIt<AppParams>()));
    when(mockAppParams.param(AppParams.starRatingThreshold)).thenReturn('60');
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('should recommend model depending on conditions', (WidgetTester tester) async {
    final sunday = DateTime(2025, 5, 4);
    final monday = DateTime(2025, 5, 5);
    const thresholdLow = '50';
    const thresholdHigh = '150';

    await prepareMovieDetailsWidget(tester, getIt, '1', sunday);
    final txt = getIt<Txt>();
    final yesString = txt.get.yes;
    final noString = txt.get.no;

    final testCaseList = [
      _MovieDetailsTestCase('high profit / Sunday', thresholdLow, sunday, yesString),
      _MovieDetailsTestCase('high profit / Monday', thresholdLow, monday, noString),
      _MovieDetailsTestCase('low profit / Sunday', thresholdHigh, sunday, noString),
      _MovieDetailsTestCase('low profit / Monday', thresholdHigh, monday, noString),
    ];

    for (final testCase in testCaseList) {
      await prepareMovieDetailsWidget(tester, getIt, testCase.profitThresh, testCase.day);
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
  when(mockAppParams.param(AppParams.recommendationProfitThreshold)).thenReturn(recommendProfitThreshold);
  when(mockDateTimeReader.now()).thenReturn(mockDay);
  await prepareWidget(tester, getit,
      widgetBuilder: () => MovieDetailsView(getit<Txt>(), title, budget, revenue, getit<MovieDetailsController>()),);
}

class _MovieDetailsTestCase {
  final String title;
  final String profitThresh;
  final DateTime day;
  final String expected;

  _MovieDetailsTestCase(this.title, this.profitThresh, this.day, this.expected);
}
