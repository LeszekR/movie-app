import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_demo/features/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_cubit.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_state.dart';
import 'package:flutter_demo/repositories/data_movies_repository.dart';

import 'common/logging/loging_messages.dart';
import 'common/ui_localized_texts/app_localizations/app_localizations.dart';
import 'common/ui_localized_texts/txt.dart';
import 'features/movie_list/view/movie_list_view.dart';
import 'get_it_model.dart';
import 'main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation/app_navigator.dart';

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
        BlocProvider(create: (context) => MovieListBloc(getit<Txt>(), getit<MoviesRepository>())),
        BlocProvider(
            create: (context) => TwoButtonCubit(TwoButtonState(buttonStates: [false, false], navCommand: null)))
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
            getit<Txt>().setLanguage(context);
            return MovieListView(
              txt: getit<Txt>(),
              appNavigator: getit<AppNavigator>(),
              moviesNavigator: getit<MovieListNavigator>(),
              scrollController: getit<MovieListScrollController>(),
            );
          },
        ),
      ),
    );
  }
}
