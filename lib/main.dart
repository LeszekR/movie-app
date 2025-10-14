import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_recruitment_task/movie_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load();
  runApp(
    const ProviderScope(
      child: MovieApp(),
    ),
  );
}
