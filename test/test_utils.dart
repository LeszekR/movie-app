import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/get_it_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_demo/domain/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';
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
          getit<Txt>().setLanguage(context);
          return Scaffold(body: widgetBuilder == null ? null : widgetBuilder());
        },
      ),
    ),
  );
}
