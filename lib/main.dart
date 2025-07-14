import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recruitment_task/data/app_config.dart';
import 'package:flutter_recruitment_task/get_it_model.dart';
import 'package:flutter_recruitment_task/movie_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool isConfigLoaded = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadConfigFile();
  if (!isConfigLoaded) {
    SystemNavigator.pop();
    return;
  }

  initGetIt();

  runApp(
    // TODO remove riverpod
    ProviderScope(
      child: const MovieApp(),
    ),
  );
}

Future<void> loadConfigFile() async {
  try {
    await dotenv.load(fileName: AppConfig.configFilePath);
    isConfigLoaded = true;
    return;
  } on FileNotFoundError {
    // TODO replace with custom exception
    print("Could not load config params - file not found: ${AppConfig.configFilePath}");
  } catch (e) {
    // TODO show error dialog to the user
    // TODO log error
    // TODO remove print(e)
    print(e);
  }
}
