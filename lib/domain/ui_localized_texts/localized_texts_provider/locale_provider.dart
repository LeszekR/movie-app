import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO use get_it and BLoC
final localeProvider = StateProvider<Locale>((ref) => const Locale('pl'));