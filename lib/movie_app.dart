import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/domain/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';
import 'package:go_router/go_router.dart';

import 'app/pages/movie_details/movie_details_view.dart';
import 'app/pages/movie_list/movie_list_view.dart';
import 'app/navigation/go_router_const_strings.dart';
import 'get_it_model.dart';
import 'main.dart';

part 'app/navigation/go_router.dart';


class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = const Locale('pl');

    // catch unhandled errors other than framework errors (those will be logged by the framework)
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
      locale: locale,
      builder: (context, child) {
        getit<Txt>().setLanguage(context);
        return child!;
      },
    );
  }
}
