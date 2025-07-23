import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/repositories/data_movies_repository.dart';
import 'package:go_router/go_router.dart';

import 'common/ui_localized_texts/app_localizations/app_localizations.dart';
import 'common/ui_localized_texts/txt.dart';
import 'features/movie_details/view/movie_details_view.dart';
import 'features/movie_list/view/movie_list_view.dart';
import 'get_it_model.dart';
import 'main.dart';
import 'navigation/go_router_const_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation/go_router.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // catch unhandled errors other than framework errors (those will be logged by the framework)
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.severe(null, error, stack);
      return true;
    };

    final locale = const Locale('pl');
    Txt.setLanguage(context);

    return MaterialApp(
      title: 'Movie Browser',
      theme: ThemeData(primarySwatch: Colors.amber),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: BlocProvider(
        create: (context) => MovieListBloc(moviesRepository: getit<MoviesRepository>()),
        child: MovieListView(),
      ),
    );
  }
}
