import 'package:flutter/cupertino.dart';

import '../app_localizations/app_localizations.dart';

class Txt {
  static late AppLocalizations _localizations;

  Txt._();

  static void setLanguage(final BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  static AppLocalizations get get => _localizations;
}
