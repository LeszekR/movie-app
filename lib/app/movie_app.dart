import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/domain/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/domain/ui_localized_texts/txt.dart';
import 'package:go_router/go_router.dart';

import '../bootstrap/app_runner.dart';
import 'pages/movie_details/view/movie_details_view.dart';
import 'pages/movie_list/view/movie_list_view.dart';
import 'navigation/go_router_const_strings.dart';
import 'pages/two_buttons/view/two_buttons_view.dart';
import '../bootstrap/get_it_model.dart';

part 'navigation/go_router.dart';


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
      theme: ThemeData(primarySwatch: AppColors.primarySwatch),
      routerConfig: goRouter(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        getIt<Txt>().setLanguage(context);
        return child!;
      },
    );
  }
}
