import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod fails to create ChangeNotifierProviders from annotation - so we do it manually here

final searchBoxTextControllerProvider = ChangeNotifierProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final movieListScrollControllerProvider = ChangeNotifierProvider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

