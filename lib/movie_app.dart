import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'common/ui_localized_texts/app_localizations/app_localizations.dart';
import 'features/movie_details/view/movie_details_view.dart';
import 'features/movie_list/view/movie_list_view.dart';
import 'main.dart';
import 'navigation/go_router_const_strings.dart';

part 'navigation/go_router.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = const Locale('pl');

    // catch unhandeld errors other than framework errors (those will be logged by the framework)
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.severe(null, error, stack);
      return true;
    };

    return MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: goRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale);
  }
}
