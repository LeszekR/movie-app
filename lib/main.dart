import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recruitment_task/data/config/app_config.dart';
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

  runApp(
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
    print("Could not load config params - file not found: ${AppConfig.configFilePath}");
  } catch (e) {
    // TODO show error dialog to the user
    // TODO log error
    // TODO remove print(e)
    print(e);
  }
}
