import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_cubit.dart';

import '../bootstrap/app_runner.dart';
import '../common/logging/logging_messages.dart';
import '../common/ui_localized_texts/app_localizations/app_localizations.dart';
import '../common/ui_localized_texts/txt.dart';
import 'movie_list/view/movie_list_view.dart';
import '../bootstrap/get_it_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../navigation/app_navigator.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // catch unhandled errors other than framework errors (those will be logged by the framework)
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.severe(LOG_ERR_FRAMEWORK_EXCEPTION, error, stack);
      return true;
    };

    final locale = const Locale('pl');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MovieListBloc>()),
        BlocProvider(create: (context) => getIt<TwoButtonCubit>()),
      ],
      child: MaterialApp(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.green),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            getIt<Txt>().setLanguage(context);
            return MovieListView(
              txt: getIt<Txt>(),
              appNavigator: getIt<AppNavigator>(),
              moviesNavigator: getIt<MovieListNavigator>(),
            );
          },
        ),
      ),
    );
  }
}
