import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/movie_app.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_store.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => MovieListStore(),
        child: const MovieApp(),
      ),
    );
