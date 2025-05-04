import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/movie_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(
      ProviderScope(
        child: const MovieApp(),
      ),
    );
