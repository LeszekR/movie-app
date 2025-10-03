import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/navigation/go_router_const_strings.dart';
import 'package:flutter_demo/app/pages/movie_app/controller/movie_app_controller.dart';
import 'package:flutter_demo/app/pages/movie_details/view/movie_details_view.dart';
import 'package:flutter_demo/app/pages/movie_list/view/movie_list_view.dart';
import 'package:flutter_demo/app/pages/two_buttons/view/two_buttons_view.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_demo/app/ui_localized_texts/txt.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';
import 'package:flutter_demo/bootstrap/logger_setup.dart';
import 'package:go_router/go_router.dart';

part '../../../navigation/go_router.dart';

class MovieApp extends CleanView {
  const MovieApp({super.key});

  @override
  State<StatefulWidget> createState() => _MovieAppState();
}

class _MovieAppState extends CleanViewState<MovieApp, MovieAppController> {
  _MovieAppState() : super(getIt<MovieAppController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder<MovieAppController>(
      builder: (context, controller) {
        final locale = Locale(controller.state.languageId);

        // catch unhandled errors other than framework errors (those will be logged by the framework)
        PlatformDispatcher.instance.onError = (error, stack) {
          log.severe(null, error, stack);
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
      },
    );
  }
}
