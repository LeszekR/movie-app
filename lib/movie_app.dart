import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/utils/routing/go_router_const_strings.dart';
import 'package:go_router/go_router.dart';

part 'utils/routing/go_router.dart';

// TODO move all hardcoded UI strings to localized resources
// TODO introduce DI
// TODO tests: sorting, navigation
// TODO finish go_route package use explanation in RECRUITMENT_TASK_COMMENTS
// TODO make sure it works, implement if not: dart in SortableSorter should throw on attempt to sort by column of bounds of sorted fields list
// TODO implement error dialog in case the browser failed to fetch data
// TODO implement retaining fetched data on return from MovieDetails page to MovieListPage

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: _router,
      );
}
