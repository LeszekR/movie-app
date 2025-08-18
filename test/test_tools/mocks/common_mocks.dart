import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/bootstrap/app_params.dart';
import 'package:flutter_demo/app/navigation/app_navigator.dart';
import 'package:flutter_demo/app/pages/movie_list/navigation/movie_list_navigator.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  AppParams,
  DateTimeReader,
  DataMovieRepository,
  AppNavigator,
  MovieListNavigator,
  ScrollController,
  TextEditingController,
])
void main() {}
