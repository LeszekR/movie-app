import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// RECRUITMENT COMMENT: Riverpod fails to create ChangeNotifierProviders from annotation - so we do it manually here

final movieListScrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

