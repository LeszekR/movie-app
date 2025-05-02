import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/movie_app.dart';
import 'package:flutter_recruitment_task/state_providers/movie_list_content.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => MovieListContent(),
        child: const MovieApp(),
      ),
    );
