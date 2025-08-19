import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> prepareWidget(
  final WidgetTester tester, {
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

Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
      Duration timeout = const Duration(seconds: 2),
      Duration step = const Duration(milliseconds: 100),
    }) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      // must be pumpAndSettle(), NOT just pump(), since in test Flutter can keep temp copies of widgets in the tree...
      // ... we want to get rid of them...
      // Even after popping a route, widgets from the previous screen might linger for a few frames in the tree
      // — just long enough to confuse find!
      await tester.pumpAndSettle();
      return;
    }
  }
  throw TestFailure('Timeout: widget not found: $finder');
}

void getItReplaceFactory<T extends Object>(T Function() builder) {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
  getIt.registerFactory<T>(builder);
}

void getItReplaceLazySingleton<T extends Object>(T Function() builder) {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
  getIt.registerLazySingleton<T>(builder);
}

void getItReplaceSingleton<T extends Object>(T Function() builder) {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
  getIt.registerSingleton<T>(builder());
}
