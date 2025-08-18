import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/common/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/common/ui_localized_texts/txt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

Future<void> prepareWidget(
  final WidgetTester tester,
  final GetIt getIt, {
  final Widget Function()? widgetBuilder,
  final String language = "pl",
}) async {
  //
  dotenv.testLoad(fileInput: File(AppParams.configFilePath).readAsStringSync());

  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (BuildContext context) {
          getIt<Txt>().setLanguage(context);
          return Scaffold(body: widgetBuilder == null ? null : widgetBuilder());
        },
      ),
    ),
  );
}
