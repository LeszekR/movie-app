import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/data/repositories/movie_repository/data_movie_repository.dart';
import 'package:flutter_demo/domain/utils/date_time_reader.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AppConfig, DateTimeReader, DataMovieRepository])
void main() {}
