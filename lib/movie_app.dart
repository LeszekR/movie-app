import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/routing/go_router_const_strings.dart';
import 'package:go_router/go_router.dart';

part 'utils/routing/go_router.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: _router,
      );
}
