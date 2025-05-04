import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_manager.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/utils/now_inject.dart';
import 'package:flutter_recruitment_task/utils/routing/go_router_const_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'utils/routing/go_router.dart';
part 'movie_app.g.dart';

class MovieApp extends ConsumerWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: ref.read(goRouterProvider),
      );
}
