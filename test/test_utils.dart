import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_demo/data/app_config.dart';
import 'package:flutter_demo/domain/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/domain/ui_localized_texts/localized_texts_provider/txt.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> prepareWidget(
  final WidgetTester tester, {
  final Widget Function()? widgetBuilder,
  final String language = "pl",
}) async {
  //
  dotenv.testLoad(fileInput: File(AppConfig.configFilePath).readAsStringSync());

  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (BuildContext context) {
          Txt.setLanguage(context);
          return Scaffold(body: widgetBuilder == null ? null : widgetBuilder());
        },
      ),
    ),
  );
}
