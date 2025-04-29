import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/pages/two_buttons/two_buttons_page.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        initialRoute: '/',
        routes: {
          '/': (context) => MovieListPage(),
          '/details': (context) => MovieDetailsPage(),
          '/two_buttons': (context) => TwoButtonsPage(),
        },
      );
}
