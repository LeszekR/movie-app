import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/domain/ui_localized_texts/app_localizations/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app/pages/movie_details/movie_details_view.dart';
import 'app/pages/movie_list/movie_list_view.dart';
import 'app/navigation/go_router_const_strings.dart';
import 'domain/ui_localized_texts/localized_texts_provider/locale_provider.dart';

part 'app/navigation/go_router.dart';
part 'app/navigation/go_router_provider.g.dart';


class MovieApp extends ConsumerWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: ref.read(goRouterProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale);
  }
}
